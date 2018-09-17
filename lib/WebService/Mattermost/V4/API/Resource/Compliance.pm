package WebService::Mattermost::V4::API::Resource::Compliance;

use Moo;

extends 'WebService::Mattermost::V4::API::Resource';

################################################################################

around [ qw(get_report_by_id download_report_by_id) ] => sub {
    my $orig = shift;
    my $self = shift;
    my $id   = shift;

    return $self->validate_id($orig, $id, @_);
};

sub create_report {
    my $self = shift;

    return $self->_post({ endpoint => 'reports' });
}

sub get_reports {
    my $self = shift;
    my $args = shift;

    return $self->_get({
        view       => 'Compliance::Report',
        endpoint   => 'reports',
        parameters => $args,
    });
}

sub get_report_by_id {
    my $self = shift;
    my $id   = shift;

    return $self->_single_view_get({
        view     => 'Compliance::Report',
        endpoint => 'reports/%s',
        ids      => [ $id ],
    });
}

sub download_report_by_id {
    my $self = shift;
    my $id   = shift;

    return $self->_single_view_get({
        view     => 'Compliance::Report',
        endpoint => 'reports/%s/download',
        ids      => [ $id ],
    });
}

################################################################################

1;
__END__

=head1 NAME

WebService::Mattermost::V4::API::Resource::Compliance

=head1 DESCRIPTION

=head2 USAGE

    use WebService::Mattermost;

    my $mm = WebService::Mattermost->new({
        authenticate => 1,
        username     => 'me@somewhere.com',
        password     => 'hunter2',
        base_url     => 'https://my.mattermost.server.com/api/v4/',
    });

    my $resource = $mm->api->compliance;

=head2 METHODS

=over 4

=item C<create_report()>

Create a new compliance report.

    my $response = $resource->create_report();

=item C<get_reports()>

Get all compliance reports.

    my $response = $resource->get_reports({
        # Optional parameters
        page     => 0,  # default values
        per_page => 60,
    });

=item C<get_report_by_id()>

Get a compliance report by its ID.

    my $response = $resource->get_report_by_id('REPORT-ID-HERE');

=item C<download_report_by_id()>

Download a compliance report by its ID.

    my $response = $resource->download_report_by_id('REPORT-ID-HERE');

=back

=head1 SEE ALSO

=over 4

=item L<Official compliance documentation|https://api.mattermost.com/#tag/compliance>

=back

=head1 AUTHOR

Mike Jones L<email:mike@netsplit.org.uk>

