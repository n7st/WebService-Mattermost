package WebService::Mattermost::API::v4::Resource::Emoji;

use Moo;

extends 'WebService::Mattermost::API::v4::Resource';

################################################################################

sub custom {
    my $self = shift;

    return $self->_get({});
}

################################################################################

1;

