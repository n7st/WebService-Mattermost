package WebService::Mattermost::V4::API::Object::Icon;

use Moo;
use Types::Standard qw(Int Maybe Str);

extends 'WebService::Mattermost::V4::API::Object';
with    'WebService::Mattermost::V4::API::Object::Role::ID';

################################################################################

has status_code => (is => 'ro', isa => Maybe[Int], lazy => 1, builder => 1);
has message     => (is => 'ro', isa => Maybe[Str], lazy => 1, builder => 1);
has request_id  => (is => 'ro', isa => Maybe[Str], lazy => 1, builder => 1);

################################################################################

1;
__END__

=head1 NAME

WebService::Mattermost::V4::API::Object::Icon

=head1 DESCRIPTION

Details a Mattermost Icon object.

=head2 ATTRIBUTES

=over 4

=item C<status_code>

=item C<message>

=item C<request_id>

=back

=head1 SEE ALSO

=over 4

=item C<WebService::Mattermost::V4::API::Object::Role::ID>

=back

=head1 AUTHOR

Mike Jones L<email:mike@netsplit.org.uk>

