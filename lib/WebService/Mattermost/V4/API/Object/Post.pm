package WebService::Mattermost::V4::API::Object::Post;

use Moo;
use Types::Standard qw(ArrayRef Maybe Str InstanceOf);

use WebService::Mattermost::Helper::Alias 'view';

extends 'WebService::Mattermost::V4::API::Object';
with    qw(
    WebService::Mattermost::V4::API::Object::Role::BelongingToChannel
    WebService::Mattermost::V4::API::Object::Role::BelongingToUser
    WebService::Mattermost::V4::API::Object::Role::ID
    WebService::Mattermost::V4::API::Object::Role::Message
    WebService::Mattermost::V4::API::Object::Role::Props
    WebService::Mattermost::V4::API::Object::Role::Timestamps
);

################################################################################

has [ qw(
    hashtag
    original_id
    parent_id
    pending_post_id
    root_id
) ] => (is => 'ro', isa => Maybe[Str], lazy => 1, builder => 1);

has [ qw(
    original_post
    parent_post
    pending_post
    root_post
) ] => (is => 'ro', isa => Maybe[InstanceOf[view 'Post']], lazy => 1, builder => 1);

has [ qw(
    filenames
    file_ids
) ] => (is => 'ro', isa => Maybe[ArrayRef], lazy => 1, builder => 1);

################################################################################

sub _get_related_post {
    my $self = shift;
    my $id   = shift;

    return unless $id;
    return $self->api->post->get($id)->item;
}

################################################################################

sub _build_hashtag         { shift->raw_data->{hashtag}         }
sub _build_original_id     { shift->raw_data->{original_id}     }
sub _build_parent_id       { shift->raw_data->{parent_id}       }
sub _build_pending_post_id { shift->raw_data->{pending_post_id} }
sub _build_root_id         { shift->raw_data->{root_id}         }
sub _build_filenames       { shift->raw_data->{filenames}       }
sub _build_file_ids        { shift->raw_data->{file_ids}        }

sub _build_original_post {
    my $self = shift;

    return $self->_get_related_post($self->original_id);
}

sub _build_parent_post {
    my $self = shift;

    return $self->_get_related_post($self->parent_id);
}

sub _build_pending_post {
    my $self = shift;

    return $self->_get_related_post($self->pending_post_id);
}

sub _build_root_post {
    my $self = shift;

    return $self->_get_related_post($self->root_id);
}

################################################################################

1;

