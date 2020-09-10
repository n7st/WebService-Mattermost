package WebService::Mattermost::V4::API::Resource::Role::View::Bot;

# ABSTRACT: Links a resource to the bot view.

use Moo::Role;
use Types::Standard 'Str';

################################################################################

has view_name => (is => 'ro', isa => Str, default => 'Bot');

################################################################################

1;
__END__

=head1 DESCRIPTION

Set a resource as using the L<WebService::Mattermost::V4::API::Object::Bot>
view.

=head1 ATTRIBUTES

=over 4

=item C<view_name>

=back
