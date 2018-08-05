package Net::Mattermost::Util::UserAgent;

use Moo;
use Mojo::UserAgent;
use Types::Standard qw(Bool InstanceOf Int);

################################################################################

has ua => (is => 'ro', isa => InstanceOf['Mojo::UserAgent'], lazy => 1, builder => 1);

has inactivity_timeout => (is => 'ro', isa => Int,  default => 15);
has insecure           => (is => 'ro', isa => Bool, default => 0); 
has max_redirects      => (is => 'ro', isa => Int,  default => 5);

################################################################################

sub _build_ua {
    my $self = shift;

    my $ua = Mojo::UserAgent->new();

    $ua->max_redirects($self->max_redirects);
    $ua->inactivity_timeout($self->inactivity_timeout);

    return $ua;
}

################################################################################

1;

