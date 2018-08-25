package WebService::Mattermost::API::View::User;

use DDP;
use Moo;
use Types::Standard qw(Bool HashRef InstanceOf Int Maybe Str);

extends 'WebService::Mattermost::API::View';

################################################################################

has [ qw(
    allow_marketing
    is_system_admin
    is_system_user
) ] => (is => 'ro', isa => Bool, lazy => 1, builder => 1);

has [ qw(
    auth_data
    auth_service
    email
    first_name
    id
    last_name
    locale
    nickname
    roles
    position
    username
) ] => (is => 'ro', isa => Maybe[Str], lazy => 1, builder => 1);

has [ qw(
    created_at
    deleted_at
    password_updated_at
    picture_updated_at
    updated_at
) ] => (is => 'ro', isa => Maybe[InstanceOf['DateTime']], lazy => 1, builder => 1);

################################################################################

sub _build_allow_marketing {
    my $self = shift;

    return $self->raw_data->{allow_marketing} ? 1 : 0;
}

sub _build_is_system_admin {
    my $self = shift;

    return $self->roles =~ /system_admin/ ? 1 : 0;
}

sub _build_is_system_user {
    my $self = shift;

    return $self->roles =~ /system_user/ ? 1 : 0;
}

sub _build_created_at {
    my $self = shift;

    return $self->_from_epoch($self->raw_data->{create_at});
}

sub _build_deleted_at {
    my $self = shift;

    return $self->_from_epoch($self->raw_data->{delete_at});
}

sub _build_password_updated_at {
    my $self = shift;

    return $self->_from_epoch($self->raw_data->{last_password_update});
}

sub _build_picture_updated_at {
    my $self = shift;

    return $self->_from_epoch($self->raw_data->{last_picture_update});
}

sub _build_updated_at {
    my $self = shift;

    return $self->_from_epoch($self->raw_data->{update_at});
}

################################################################################

1;

