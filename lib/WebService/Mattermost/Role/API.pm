package WebService::Mattermost::Role::API;

use Moo::Role;
use Types::Standard qw(Object Str);

use WebService::Mattermost::API;

################################################################################

has base_url => (is => 'ro', isa => Str, required => 1);

has api_version => (is => 'ro', isa => Str, default => 'v4');

has api => (is => 'ro', isa => Object, lazy => 1, builder => 1);

################################################################################

sub _build_api {
    my $self = shift;

    my $wrapper = WebService::Mattermost::API->new({
        base_url => $self->base_url,
    });

    my $version = $self->api_version;

    return $wrapper->$version;
}

################################################################################

1;
__END__

=head1 NAME

WebService::Mattermost::Role::API

=head1 DESCRIPTION

Add access to the Mattermost API to a class.

=head2 USAGE

    use Moo;

    with 'WebService::Mattermost::Role::API';

    sub something {
        my $self = shift;

        # API available under $self->api->[...]
    }

=head2 ATTRIBUTES

=over 4

=item C<base_url>

The base URL of your Mattermost API, including the version. Example:
C<https://my.mattermost.server.com/api/v4/>.

=item C<api>

The accessor for the API library.

=back

=head1 AUTHOR

Mike Jones L<email:mike@netsplit.org.uk>

