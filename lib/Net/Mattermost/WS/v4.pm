package Net::Mattermost::WS::v4;

use DDP;
use Mojo::IOLoop;
use Mojo::JSON qw(decode_json encode_json);
use Moo;
use MooX::HandlesVia;
use Types::Standard qw(Bool Int Str);

extends 'Net::Mattermost';
with    qw(
    Net::Mattermost::Role::Logger
    Net::Mattermost::Role::UserAgent
);

################################################################################

has websocket_url => (is => 'ro', isa => Str, lazy => 1, builder => 1);

has ping_interval => (is => 'ro', isa => Int,  default => 15);
has ignore_self   => (is => 'ro', isa => Bool, default => 1);
has debug         => (is => 'ro', isa => Bool, default => 0);
has last_seq      => (is => 'rw', isa => Int,  default => 1,
    handles_via => 'Number',
    handles     => {
        inc_last_seq => 'add',
    });

################################################################################

sub BUILD {
    my $self = shift;

    $self->authenticate(1);

    return $self->next::method(@_);
}

sub connect {
    my $self = shift;
    my $re   = shift;

    # Spawn a unique user-agent for the gateway rather than using the
    # role-packaged one. We still need the headers from the UserAgent role
    # which will also be applied to this one.
    my $ua = Mojo::UserAgent->new();

    $ua->on(start => sub { $self->_on_start(@_) });

    $ua->websocket($self->websocket_url => sub {
        my ($ua, $tx) = @_;

        unless ($tx->is_websocket) {
            $self->logger->logdief('WebSocket handshake failed: %s', $tx->res->error->{message});
        }

        Mojo::IOLoop->recurring(15 => sub { $self->_ping($tx) });

        $tx->on(error   => sub { $self->_on_error(@_)   });
        $tx->on(finish  => sub { $self->_on_finish(@_)  });
        $tx->on(message => sub { $self->_on_message(@_) });
    });

    return Mojo::IOLoop->start if !Mojo::IOLoop->is_running || $re;
}

################################################################################

sub _ping {
    my $self = shift;
    my $tx   = shift;

    if ($self->debug) {
        $self->logger->debugf('[Seq: %d] Ping', $self->last_seq);
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

    # Clear up stale Mojo::IOLoop items so the bot can reconnect
    Mojo::IOLoop->reset();

    $self->logger->infof('WebSocket connection closed: [%d] %s', $code, $reason);

    return $self->_reconnect();
}

sub _on_message {
    my $self    = shift;
    my $tx      = shift;
    my $message = decode_json(shift);

    if ($message->{seq}) {
        $self->last_seq($message->{seq});
    }

    p $message;

    return unless $message && $message->{event};

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

sub _on_error {
    my $self    = shift;
    my $ws      = shift;
    my $message = shift;

    return $ws->finish($message);
}

sub _reconnect {
    my $self = shift;

    $self->_try_authentication();

    return $self->connect(1);
}

################################################################################

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

