package WebService::Mattermost::V4::API::Object::Analytics::Old;

# ABSTRACT: An "old" Analytics item.

use Moo;
use Types::Standard qw(Int Maybe);

extends 'WebService::Mattermost::V4::API::Object';
with    qw(
    WebService::Mattermost::V4::API::Object::Role::Name
    WebService::Mattermost::V4::API::Object::Role::Value
);

################################################################################

1;
__END__

=head1 DESCRIPTION

Details an old Mattermost analytics item.

=head1 SEE ALSO

=over 4

=item L<WebService::Mattermost::V4::API::Object::Role::Name>

=item L<WebService::Mattermost::V4::API::Object::Role::Value>

=back
