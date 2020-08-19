package WebService::Mattermost::V4::API::Resource::Role::View::Team;

# ABSTRACT: Links a resource to the team view.

use Moo::Role;
use Types::Standard 'Str';

################################################################################

has view_name => (is => 'ro', isa => Str, default => 'Team');

################################################################################

1;
__END__

=head1 DESCRIPTION

Set a resource as using the L<WebService::Mattermost::V4::API::Object::Team>
view.

=head1 ATTRIBUTES

=over 4

=item C<view_name>

=back
