package Net::Mattermost::API::v4::Resource::Channels;

use Moo;

extends 'Net::Mattermost::API::v4::Resource';

################################################################################

sub create {
    # POST /
}

sub create_direct_message {
    # POST /direct
}

sub create_group_message {
    # POST /group
}

sub get {
    # GET /{id}
}

sub update {
    # PUT /{id}
}

sub delete {
    # DELETE /{id}
}

sub patch {
    # PUT /{id}/patch
}

sub convert {
    # POST /{id}/convert
}

sub restore {
    # POST /{id}/restore
}

sub stats {
    # GET /{id}/stats
}

sub pinned {
    # GET /{id}/pinned
}

sub members {
    # GET /{id}/members
}

sub add_member {
    # POST /{id}/members
}

sub members_by_ids {
    # POST /{id}/members/ids
}

sub member_by_id {
    # GET /{id}/members/{user_id}
}

sub remove_member {
    # DELETE /{id}/members/{user_id}
}

sub update_roles {
    # PUT /{id}/members/{user_ids}/roles
}

################################################################################

1;

