package WebService::Mattermost::V4::API::Object::Bot;

# ABSTRACT: A bot item.

use Moo;
use Types::Standard 'Str';

extends 'WebService::Mattermost::V4::API::Object';
with    qw(
    WebService::Mattermost::V4::API::Object::Role::BelongingToUser
    WebService::Mattermost::V4::API::Object::Role::Timestamps
);

################################################################################

has description  => (is => 'ro', isa => Str, lazy => 1, builder => '_build_description');
has display_name => (is => 'ro', isa => Str, lazy => 1, builder => '_build_display_name');
has username     => (is => 'ro', isa => Str, lazy => 1, builder => '_build_username');
has user_id      => (is => 'ro', isa => Str, lazy => 1, builder => '_build_user_id');

################################################################################

sub _build_description  { shift->raw_data->{description}  }
sub _build_display_name { shift->raw_data->{display_name} }
sub _build_username     { shift->raw_data->{username}     }
sub _build_user_id      { shift->raw_data->{user_id}      }

################################################################################

1;
__END__

=head1 DESCRIPTION

Object version of a Mattermost bot user.

=head2 ATTRIBUTES

=over 4

=item * C<description>

=item * C<display_name>

=item * C<username>

=item * C<user_id>

=back

=head1 SEE ALSO

=over 4

=item * L<WebService::Mattermost::V4::API::Object::Role::BelongingToUser>

=item * L<WebService::Mattermost::V4::API::Object::Role::Timestamp>

=back

