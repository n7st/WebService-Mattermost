package WebService::Mattermost::API::v4::Resource::Jobs;

use Moo;

extends 'WebService::Mattermost::API::v4::Resource';

################################################################################

around [ qw(get_by_id cancel_by_id) ] => sub {
    my $orig = shift;
    my $self = shift;
    my $id   = shift;

    return $self->_validate_id($orig, $id, @_);
};

sub all {
    my $self = shift;
    my $args = shift;

    return $self->_single_view_get({
        view       => 'Job',
        parameters => $args,
    });
}

sub create {
    my $self = shift;
    my $args = shift;

    return $self->_single_view_post({
        view       => 'Job',
        parameters => $args,
        required   => [ 'type' ],
    });
}

sub get_by_id {
    my $self = shift;
    my $id   = shift;

    return $self->_single_view_get({
        view     => 'Job',
        endpoint => '%s',
        ids      => [ $id ],
    });
}

sub cancel_by_id {
    my $self = shift;
    my $id   = shift;

    return $self->_single_view_post({
        view     => 'Job',
        endpoint => '%s/cancel',
        ids      => [ $id ],
    });
}

sub get_by_type {
    my $self = shift;
    my $type = shift;

    unless ($type) {
        return $self->_error_return('The first argument must be a job type');
    }

    return $self->_get({
        view     => 'Job',
        endpoint => 'type/%s',
        ids      => [ $type ],
    });
}

################################################################################

1;
__END__

=head1 NAME

WebService::Mattermost::API::v4::Resource::Jobs

=head1 DESCRIPTION

=head2 USAGE

    use WebService::Mattermost;

    my $mm = WebService::Mattermost->new({
        authenticate => 1,
        username     => 'me@somewhere.com',
        password     => 'hunter2',
        base_url     => 'https://my.mattermost.server.com/api/v4/',
        });

    my $resource = $mm->api->teams->jobs;

=head2 METHODS

=over 4

=item C<all()>

L<Get the jobs|https://api.mattermost.com/#tag/jobs%2Fpaths%2F~1jobs%2Fget>

Get all the jobs.

    my $response = $resource->all({
        # Optional arguments
        page     => 0,
        per_page => 60,
    });

=item C<create()>

L<Create a new job|https://api.mattermost.com/#tag/jobs%2Fpaths%2F~1jobs%2Fpost>

    my $response = $resource->create({
        # Required arguments
        type => 'JOB-TYPE',

        # Optional arguments
        data => {},
    });

=item C<get_by_id()>

L<Get a job|https://api.mattermost.com/#tag/jobs%2Fpaths%2F~1jobs~1%7Bjob_id%7D%2Fget>

    my $response = $resource->get_by_id('JOB-ID-HERE');

=item C<cancel_by_id()>

L<Cancel a job|https://api.mattermost.com/#tag/jobs%2Fpaths%2F~1jobs~1%7Bjob_id%7D~1cancel%2Fpost>

    my $response = $resource->cancel_by_id('JOB-ID-HERE');

=item C<get_by_type()>

L<https://api.mattermost.com/#tag/jobs%2Fpaths%2F~1jobs~1type~1%7Btype%7D%2Fget>

    my $response = $resource->get_by_type('JOB-TYPE-HERE');

=back

=head1 SEE ALSO

=over 4

=item L<Official Jobs documentation|https://api.mattermost.com/#tag/jobs>

=back

=head1 AUTHOR

Mike Jones L<email:mike@netsplit.org.uk>

