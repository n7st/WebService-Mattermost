package Net::Mattermost::API::v4::Resource::Users::Status;

use Moo;

extends 'Net::Mattermost::API::v4::Resource';

################################################################################

sub get_by_id {
    my $self = shift;
    my $id   = shift;

    return $self->_call({
        method   => $self->get,
        endpoint => '%s/status',
        ids      => [ $id ],
    });
}

sub set_by_id {
    my $self   = shift;
    my $id     = shift;
    my $status = shift;

    return $self->_call({
        method     => $self->put,
        endpoint   => '%s/status',
        ids        => [ $id ],
        parameters => {
            status => $status,
        },
    });
}

sub get_by_ids {
    my $self = shift;
    my $ids  = shift;

    return $self->_call({
        method     => $self->post,
        endpoint   => 'status/ids',
        parameters => $ids,
    });
}

################################################################################

1;

