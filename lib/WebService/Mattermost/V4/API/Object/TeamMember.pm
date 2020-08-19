package WebService::Mattermost::V4::API::Object::TeamMember;

# ABSTRACT: A team member item.

use Moo;

extends 'WebService::Mattermost::V4::API::Object';
with    qw(
    WebService::Mattermost::V4::API::Object::Role::BelongingToUser
    WebService::Mattermost::V4::API::Object::Role::BelongingToTeam
    WebService::Mattermost::V4::API::Object::Role::Roles
);

################################################################################

1;
__END__

=head1 DESCRIPTION

Details a Mattermost TeamMember object.

=head1 SEE ALSO

=over 4

=item L<WebService::Mattermost::V4::API::Object::Role::BelongingToUser>

=item L<WebService::Mattermost::V4::API::Object::Role::BelongingToTeam>

=item L<WebService::Mattermost::V4::API::Object::Role::Roles>

=back
