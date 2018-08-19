package Net::Mattermost::WS::v4;

use DDP;
use Mojo::IOLoop;
use Mojo::JSON qw(decode_json encode_json);
use Moo;
use MooX::HandlesVia;
use Types::Standard qw(ArrayRef Bool InstanceOf Int Maybe Str);

extends 'Net::Mattermost';
with    qw(
    Net::Mattermost::Role::Logger
    Net::Mattermost::Role::UserAgent
);

################################################################################

has ioloop        => (is => 'rw', isa => InstanceOf['Mojo::IOLoop'],    lazy => 1, builder => 1);
has websocket_url => (is => 'ro', isa => Str,                           lazy => 1, builder => 1);
has _ua           => (is => 'rw', isa => InstanceOf['Mojo::UserAgent'], lazy => 1, builder => 1);

has ws => (is => 'rw', isa => Maybe[InstanceOf['Mojo::Base']]);

has debug                  => (is => 'ro', isa => Bool, default => 0);
has ignore_self            => (is => 'ro', isa => Bool, default => 1);
has ping_interval          => (is => 'ro', isa => Int,  default => 15);
has reconnection_wait_time => (is => 'ro', isa => Int,  default => 2);
has last_seq               => (is => 'rw', isa => Int,  default => 1,
    handles_via => 'Number',
    handles     => {
        inc_last_seq => 'add',
    });
has loops                  => (is => 'rw', isa => ArrayRef[InstanceOf['Mojo::IOLoop']], default => sub { [] },
    handles_via => 'Array',
    handles     => {
        add_loop    => 'push',
        clear_loops => 'clear',
    });

################################################################################

sub BUILD {
    my $self = shift;

    $self->authenticate(1);

    return $self->next::method(@_);
}

sub start {
    my $self = shift;
    my $re   = shift;

    $self->_connect();
    $self->ioloop->start unless $self->ioloop->is_running();

    return;
}

################################################################################

sub _connect {
    my $self = shift;

    $self->_ua->on(start => sub { $self->_on_start(@_) });

    $self->_ua->websocket($self->websocket_url => sub {
        my ($ua, $tx) = @_;

        $self->ws($tx);

        unless ($tx->is_websocket) {
            $self->logger->logdief('WebSocket handshake failed: %s', $tx->res->error->{message});
        }

        $self->logger->debug('Adding ping loop');
        $self->add_loop($self->ioloop->recurring(15 => sub { $self->_ping($tx) }));

        $tx->on(error   => sub { $self->_on_error(@_)   });
        $tx->on(finish  => sub { $self->_on_finish(@_)  });
        $tx->on(message => sub { $self->_on_message(@_) });
    });

    return 1;
}

sub _ping {
    my $self = shift;
    my $tx   = shift;

    if ($self->debug) {
        $self->logger->debugf('[Seq: %d] Sending ping', $self->last_seq);
    }

    return $tx->send(encode_json({
        seq    => $self->last_seq,
        action => 'ping',
    }));
}

sub _on_start {
    my $self = shift;
    my $ua   = shift;
    my $tx   = shift;

    if ($self->debug) {
        $self->logger->debugf('UserAgent connected to %s', $tx->req->url->to_string);
        $self->logger->debugf('Auth token: %s', $self->auth_token);
    }

    # The methods here are from the UserAgent role
    $tx->req->headers->header('Cookie'        => $self->mmauthtoken($self->auth_token));
    $tx->req->headers->header('Authorization' => $self->bearer($self->auth_token));
    $tx->req->headers->header('Keep-Alive'    => 1);

    return 1;
}

sub _on_finish {
    my $self   = shift;
    my $tx     = shift;
    my $code   = shift;
    my $reason = shift || 'Unknown';

    $self->logger->infof('WebSocket connection closed: [%d] %s', $code, $reason);
    $self->logger->infof('Reconnecting in %d seconds...', $self->reconnection_wait_time);

    $self->ws->finish;

    # Delay the reconnection a little
    Mojo::IOLoop->timer($self->reconnection_wait_time => sub {
        return $self->_reconnect();
    });
}

sub _on_message {
    my $self    = shift;
    my $tx      = shift;
    my $message = decode_json(shift);

    if ($message->{seq}) {
        $self->logger->debugf('[Seq: %d]', $message->{seq}) if $self->debug;
        $self->last_seq($message->{seq});
    }

    p $message;

    return $self->_on_non_event($message) unless $message && $message->{event};

    my $output;

    #if ($self->ignore_self && $message->{data}->{post}) {
    if ($message->{data}->{post}) {
        my $post_data = decode_json($message->{data}->{post});

        if ($post_data->{message} eq '!die') {
            $tx->finish(1010, 'Requested');
        }

        # TODO
        #return if $post_data->{user_id} = $self->user_id;
    }

    if ($message->{event} eq 'hello') {
        if ($self->debug) {
            $self->logger->debug('Received "hello" event, sending authentication challenge');
        }

        $output = {
            seq    => 1,
            action => 'authentication_challenge',
            data   => { token => $self->auth_token },
        };
    }

    if ($output) {
        # p $output;
        $tx->send(encode_json($output));
    }

    return 1;
}

sub _on_non_event {
    my $self    = shift;
    my $message = shift;

    if ($self->debug && $message->{data} && $message->{data}->{text}) {
        $self->logger->debugf('[Seq: %d] Received %s', $self->last_seq, $message->{data}->{text});
    }

    return 1;
}

sub _on_error {
    my $self    = shift;
    my $ws      = shift;
    my $message = shift;

    return $ws->finish($message);
}

sub _reconnect {
    my $self = shift;

    # Reset things which have been altered during the course of the last
    # connection
    $self->last_seq(1);
    $self->_try_authentication();
    $self->_clean_up_loops();
    $self->ws(undef);
    $self->_ua($self->_build__ua);

    return $self->_connect();
}

sub _clean_up_loops {
    my $self = shift;

    foreach my $loop (@{$self->loops}) {
        $self->ioloop->remove($loop);
    }

    return $self->clear_loops();
}

################################################################################

sub _build__ua { Mojo::UserAgent->new }

sub _build_ioloop { Mojo::IOLoop->singleton }

sub _build_websocket_url {
    my $self = shift;

    my $ws_url = $self->base_url;

    if ($ws_url !~ /\/$/) {
        $ws_url .= '/';
    }

    $ws_url .= 'websocket';
    $ws_url =~ s/^http(?:s)?/wss/s;

    return $ws_url;
}

################################################################################

1;

