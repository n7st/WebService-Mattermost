package WebService::Mattermost::V4::API::Resource::Role::View::Channel;

# ABSTRACT: Links a resource to the channel view.

use Moo::Role;
use Types::Standard 'Str';

################################################################################

has view_name => (is => 'ro', isa => Str, default => 'Channel');

################################################################################

1;
__END__

=head1 DESCRIPTION

Set a resource as using the L<WebService::Mattermost::V4::API::Object::Channel>
view.

=head1 ATTRIBUTES

=over 4

=item C<view_name>

=back
