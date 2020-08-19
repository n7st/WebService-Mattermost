package WebService::Mattermost::Util::UserAgent;

# ABSTRACT: Internal user agent.

use Moo;
use Mojo::UserAgent;
use Types::Standard qw(Bool InstanceOf Int);

################################################################################

has ua => (is => 'ro', isa => InstanceOf['Mojo::UserAgent'], lazy => 1, builder => 1);

has inactivity_timeout => (is => 'ro', isa => Int,  default => 15);
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
__END__

=head1 DESCRIPTION

Adds standard parameters to C<Mojo::UserAgent>.

=head2 ATTRIBUTES

=over 4

=item C<ua>

A C<Mojo::Log> object.

=item C<inactivity_timeout()>

The default inactivity timeout (15 seconds).

=item C<max_redirects()>

The default maximum number of redirects (5).

=back
