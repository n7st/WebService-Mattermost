package WebService::Mattermost::API::View::Error;

use Moo;
use Types::Standard qw(Str Int Maybe);

extends 'WebService::Mattermost::API::View';

################################################################################

has [ qw(
    detailed_error
    id
    message
    request_id
) ] => (is => 'ro', isa => Maybe[Str], lazy => 1, builder => 1);

has status_code => (is => 'ro', isa => Maybe[Int], lazy => 1, builder => 1);

################################################################################

sub _build_detailed_error {
    my $self = shift;

    return $self->raw_data->{detailed_error};
}

sub _build_id {
    my $self = shift;

    return $self->raw_data->{id};
}

sub _build_message {
    my $self = shift;

    return $self->raw_data->{message};
}

sub _build_request_id {
    my $self = shift;

    return $self->raw_data->{request_id};
}

sub _build_status_code {
    my $self = shift;

    return $self->raw_data->{status_code};
}

################################################################################

1;

