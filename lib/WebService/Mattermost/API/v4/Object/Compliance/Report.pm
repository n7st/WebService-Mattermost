package WebService::Mattermost::API::v4::Object::Compliance::Report;

use Moo;
use Types::Standard qw(Str InstanceOf Int Maybe);

extends 'WebService::Mattermost::API::v4::Object';
with    qw(
    WebService::Mattermost::API::v4::Object::Role::ID
    WebService::Mattermost::API::v4::Object::Role::Status
    WebService::Mattermost::API::v4::Object::Role::CreatedAt
    WebService::Mattermost::API::v4::Object::Role::BelongingToUser
);

################################################################################

has [ qw(count start_at end_at) ]     => (is => 'ro', isa => Maybe[Int], lazy => 1, builder => 1);
has [ qw(desc type keywords emails) ] => (is => 'ro', isa => Maybe[Str], lazy => 1, builder => 1);

has [ qw(
    started_at
    ended_at
) ] => (is => 'ro', isa => Maybe[InstanceOf['DateTime']], lazy => 1, builder => 1);

################################################################################

sub _build_count {
    my $self = shift;

    return $self->raw_data->{count};
}

sub _build_start_at {
    my $self = shift;

    return $self->raw_data->{start_at};
}

sub _build_end_at {
    my $self = shift;

    return $self->raw_data->{end_at};
}

sub _build_desc {
    my $self = shift;

    return $self->raw_data->{desc};
}

sub _build_type {
    my $self = shift;

    return $self->raw_data->{type};
}

sub _build_keywords {
    my $self = shift;

    return $self->raw_data->{keywords};
}

sub _build_emails {
    my $self = shift;

    return $self->raw_data->{emails};
}

################################################################################

1;

