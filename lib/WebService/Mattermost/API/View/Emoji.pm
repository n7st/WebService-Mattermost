package WebService::Mattermost::API::View::Emoji;

use Moo;
use Types::Standard qw(Str Int);

extends 'WebService::Mattermost::API::View';
with    'WebService::Mattermost::API::View::Role::Timestamps';

################################################################################

has [ qw(id creator_id name) ] => (is => 'ro', isa => Str, lazy => 1, builder => 1);

################################################################################

sub _build_id {
    my $self = shift;

    return $self->raw_data->{id};
}

sub _build_creator_id {
    my $self = shift;

    return $self->raw_data->{id};
}

################################################################################

1;

