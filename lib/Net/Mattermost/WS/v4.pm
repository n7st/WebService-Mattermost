package Net::Mattermost::WS::v4;

use DDP;
use Mojo::IOLoop;
use Mojo::JSON qw(decode_json encode_json);
use Moo;
use Types::Standard qw(Bool Int Str);

extends 'Net::Mattermost';
with    'Net::Mattermost::Role::UserAgent';

################################################################################

has auth_token => (is => 'ro', isa => Str, required => 1);

has websocket_url => (is => 'ro', isa => Str, lazy => 1, builder => 1);

has ping_interval => (is => 'ro', isa => Int,  default => 15);
has ignore_self   => (is => 'ro', isa => Bool, default => 1);
has last_seq      => (is => 'rw', isa => Int,  default => 0);

################################################################################

sub connect {
    my $self = shift;

    $self->ua->on(start => sub { $self->on_start(@_) });

    $self->ua->websocket($self->websocket_url => sub {
        my ($ua, $tx) = @_;

        unless ($tx->is_websocket) {
            die 'WebSocket handshake failed';
        }

        Mojo::IOLoop->recurring(15 => sub {
            my $last_seq = $self->last_seq;
            $self->last_seq($last_seq++);
            p $self->last_seq;
            $tx->send(encode_json({ seq => ++$last_seq, action => 'ping' }));
        });

        $tx->on(message => sub { $self->on_message(@_) });
        $tx->on(finish  => sub { $self->on_finish(@_)  });
        $tx->on(error   => sub { $self->on_error(@_)   });
    });

    return Mojo::IOLoop->start unless Mojo::IOLoop->is_running;
}

sub on_start {
    my $self = shift;
    my $ua   = shift;
    my $tx   = shift;

    $tx->req->headers->header('Cookie'        => $self->mmauthtoken($self->auth_token));
    $tx->req->headers->header('Authorization' => $self->bearer($self->auth_token));
    $tx->req->headers->header('Keep-Alive'    => 1);

    print "Started\n";

    return 1;
}

sub on_finish {
    my $self   = shift;
    my $tx     = shift;
    my $code   = shift;
    my $reason = shift || 'Unknown';

    # Clear up stale Mojo::IOLoop items so the bot can reconnect
    Mojo::IOLoop->reset();

    p $code;
    p $reason;
}

sub on_message {
    my $self    = shift;
    my $tx      = shift;
    my $message = decode_json(shift);

    $self->last_seq($message->{seq}) if $message->{seq};

    return unless $message && $message->{event};

    my $output;

    if ($self->ignore_self && $message->{data}->{post}) {
        my $post_data = decode_json($message->{data}->{post});

        # TODO
        #return if $post_data->{user_id} = $self->user_id;
    }

    if ($message->{event} eq 'hello') {
        $output = {
            action => 'authentication_challenge',
            data   => { token => $self->auth_token },
            seq    => 1,
        };
    }

    if ($output) {
        p $output;
        $tx->send(encode_json($output));
    }

    return 1;
}

sub on_error {
    my $self    = shift;
    my $ws      = shift;
    my $message = shift;

    return $ws->finish($message);
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

