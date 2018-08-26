package WebService::Mattermost::API::View::Channel;

use DDP;
use Moo;
use Types::Standard qw(HashRef InstanceOf Int Maybe Str);

use WebService::Mattermost::Helper::Alias 'view';

extends 'WebService::Mattermost::API::View';

################################################################################

has [ qw(
    created_at
    delete_at
    extra_updated_at
    last_post_at
    updated_at
) ] => (is => 'ro', isa => Maybe[InstanceOf['DateTime']], lazy => 1, builder => 1);

has [ qw(
    creator_id
    display_name
    header
    id
    name
    purpose
    team_id
    type
) ] => (is => 'ro', isa => Maybe[Str], lazy => 1, builder => 1);

has [ qw(
    total_message_count
) ] => (is => 'ro', isa => Maybe[Int], lazy => 1, builder => 1);

# TODO
#has created_by => (is => 'ro', isa => Maybe[InstanceOf[view 'User']], lazy => 1, builder => 1);
#has team       => (is => 'ro', isa => Maybe[InstanceOf[view 'Team']], lazy => 1, builder => 1);

################################################################################

sub _build_created_at {
    my $self = shift;

    return $self->_from_epoch($self->raw_data->{create_at});
}

sub _build_delete_at {
    my $self = shift;

    return $self->_from_epoch($self->raw_data->{delete_at});
}

sub _build_extra_updated_at {
    my $self = shift;

    return $self->_from_epoch($self->raw_data->{extra_updated_at});
}

sub _build_updated_at {
    my $self = shift;

    return $self->_from_epoch($self->raw_data->{updated_at});
}

sub _build_creator_id {
    my $self = shift;

    return $self->raw_data->{creator_id};
}

sub _build_display_name {
    my $self = shift;

    return $self->raw_data->{display_name};
}

sub _build_header {
    my $self = shift;

    return $self->raw_data->{header};
}

sub _build_id {
    my $self = shift;

    return $self->raw_data->{id};
}

sub _build_name {
    my $self = shift;

    return $self->raw_data->{name};
}

sub _build_purpose {
    my $self = shift;

    return $self->raw_data->{purpose};
}

sub _build_team_id {
    my $self = shift;

    return $self->raw_data->{team_id};
}

sub _build_type {
    my $self = shift;

    return $self->raw_data->{type} eq 'O' ? 'Public' : 'Private';
}

sub _build_total_message_count {
    my $self = shift;

    return $self->raw_data->{total_message_count};
}

# TODO
#sub _build_created_by {
#    my $self = shift;
#
#    return unless $self->creator_id;
#    my $ret = $self->api->users->get_by_id($self->creator_id);
#
#    p $self->base_url;
#    p $self->auth_token;
#    p $ret;
#
#    return undef;
#}

################################################################################

1;

