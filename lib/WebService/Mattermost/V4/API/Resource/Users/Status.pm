package WebService::Mattermost::V4::API::Resource::Users::Status;

use Moo;

extends 'WebService::Mattermost::V4::API::Resource';

################################################################################

around [ qw(get_by_id set_by_id) ] => sub {
    my $orig = shift;
    my $self = shift;
    my $id   = shift;

    return $self->validate_id($orig, $id, @_);
};

sub get_by_id {
    my $self = shift;
    my $id   = shift;

    return $self->_get({
        endpoint => '%s/status',
        ids      => [ $id ],
    });
}

sub set_by_id {
    my $self   = shift;
    my $id     = shift;
    my $status = shift;

    return $self->_put({
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

    unless (scalar @{$ids}) {
        return $self->_error_return('The second argument should be an arrayref of user_ids');
    }

    return $self->_post({
        endpoint   => 'status/ids',
        parameters => $ids,
    });
}

################################################################################

1;
__END__

=head1 NAME

WebService::Mattermost::V4::API::Resource::Users::Status

=head1 DESCRIPTION

=head2 USAGE

    use WebService::Mattermost;

    my $mm = WebService::Mattermost->new({
        authenticate => 1,
        username     => 'me@somewhere.com',
        password     => 'hunter2',
        base_url     => 'https://my.mattermost.server.com/api/v4/',
    });

    my $resource = $mm->api->users->status;

=head2 METHODS

=over 4

=item C<get_by_id()>

Get a user's status by their user ID.

    $resource->get_by_id('USER-ID-HERE');

=item C<set_by_id()>

Set a user's status by their user ID.

    $resource->set_by_id('USER-ID-HERE');

=item C<get_by_ids()>

Get user statuses by multiple user IDs.

    $resource->get_by_ids([ 'USER-ID-HERE', 'ANOTHER-USER-ID-HERE' ]);

=back

=head1 SEE ALSO

=over 4

=item L<Official Status documentation|https://api.mattermost.com/#tag/status>

=back

=head1 AUTHOR

Mike Jones L<email:mike@netsplit.org.uk>

