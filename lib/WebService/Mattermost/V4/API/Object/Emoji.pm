package WebService::Mattermost::V4::API::Object::Emoji;

use Moo;
use Types::Standard qw(Str Int);

extends 'WebService::Mattermost::V4::API::Object';
with    qw(
    WebService::Mattermost::V4::API::Object::Role::Timestamps
    WebService::Mattermost::V4::API::Object::Role::BelongingToUser
    WebService::Mattermost::V4::API::Object::Role::ID
    WebService::Mattermost::V4::API::Object::Role::Name
);

################################################################################

1;
__END__

=head1 NAME

WebService::Mattermost::V4::API::Object::Emoji

=head1 DESCRIPTION

Details a Mattermost Emoji object.

=head1 SEE ALSO

=over 4

=item C<WebService::Mattermost::V4::API::Object::Role::Timestamps>

=item C<WebService::Mattermost::V4::API::Object::Role::BelongingToUser>

=item C<WebService::Mattermost::V4::API::Object::Role::ID>

=item C<WebService::Mattermost::V4::API::Object::Role::Name>

=back

=head1 AUTHOR

Mike Jones L<email:mike@netsplit.org.uk>

