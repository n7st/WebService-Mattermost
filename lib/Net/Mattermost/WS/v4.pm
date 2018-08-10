package Net::Mattermost::WS::v4;

use DDP;
use Mojo::IOLoop;
use Mojo::UserAgent;
use Moo;
use Types::Standard qw(Int Str);

extends 'Net::Mattermost';

################################################################################

has auth_token    => (is => 'ro', isa => Str, required => 1);

has websocket_url => (is => 'ro', isa => Str, lazy => 1, builder => 1);

has ping_interval => (is => 'ro', isa => Int, default => 15);

################################################################################

sub connect {
    my $self = shift;

    my $ua = Mojo::UserAgent->new();

    $ua->on(start => sub {
        my ($ua, $tx) = @_;

        print "Started\n";
    });

    $ua->websocket($self->websocket_url => sub {
        my ($ua, $tx) = @_;

        my $last = 0;

        Mojo::IOLoop->recurring($self->ping_interval => sub {
            $tx->send(json => { seq => ++$last, action => 'ping' });
        });

        $tx->on(finish => sub {
            my ($tx, $code, $reason) = @_;
            p $code; p $reason;
            die;
        });

        $tx->on(message => sub {
            my ($tx, $message) = @_;

            p $message;
        });

        $tx->on(error => sub {
            my ($ws, $message) = @_;

            return $ws->finish($message);
        });
    });

    return Mojo::IOLoop->start unless Mojo::IOLoop->is_running;
}

################################################################################

sub _build_websocket_url {
    my $self = shift;

    my $ws_url = $self->base_url;

    if ($ws_url !~ /\/^/) {
        $ws_url .= '/';
    }

    $ws_url .= 'websocket';
    $ws_url =~ s/^http(?:s)?/wss/s;

    return $ws_url;
}

################################################################################

1;

