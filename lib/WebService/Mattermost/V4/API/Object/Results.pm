package WebService::Mattermost::V4::API::Object::Results;

# ABSTRACT: A result object.

use Moo;
use Types::Standard qw(Maybe Str);

extends 'WebService::Mattermost::V4::API::Object';

################################################################################

has results => (is => 'ro', isa => Maybe[Str], lazy => 1, builder => 1);

################################################################################

sub _build_results { shift->raw_data->{results} }

################################################################################

1;
__END__

=head1 DESCRIPTION

Details a Mattermost Results object. Returned only by L<WebService::Mattermost::V4::API::Resource::Team>'s
C<import_from_existing()> method.

=head2 ATTRIBUTES

=over 4

=item * C<results>

Stringified "results".

=back
