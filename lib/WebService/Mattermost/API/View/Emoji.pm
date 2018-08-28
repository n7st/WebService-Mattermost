package WebService::Mattermost::API::View::Emoji;

use Moo;
use Types::Standard qw(Str Int);

extends 'WebService::Mattermost::API::View';
with    qw(
    WebService::Mattermost::API::View::Role::Timestamps
    WebService::Mattermost::API::View::Role::BelongingToUser
    WebService::Mattermost::API::View::Role::ID
    WebService::Mattermost::API::View::Role::Name
);

################################################################################

1;

