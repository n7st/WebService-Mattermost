package Net::Mattermost::API::v4::Resource::Teams;

use Moo;

extends 'Net::Mattermost::API::v4::Resource';

################################################################################

sub channels_by_id {
    # POST /{id}/channels/ids
}

sub public_channels {
    # GET /{id}/channels
}

sub deleted_channels {
    # GET /{id}/channels/deleted
}

sub autocomplete_channels {
    # GET /{id}/channels/autocomplete
}

sub search_channels {
    # POST /{id}/channels/search
}

sub channel_by_name {
    # GET /{id}/channels/name/{name}
}

sub channel_by_name_and_team_name {
    # GET /name/{name}/channels/name/{channel_name}
}

################################################################################

1;

