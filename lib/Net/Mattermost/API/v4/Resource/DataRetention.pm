package Net::Mattermost::API::v4::Resource::DataRetention;

use Moo;

extends 'Net::Mattermost::API::v4::Resource';

################################################################################

sub policy {
    my $self = shift;

    return $self->_call({
        method   => $self->get,
        endpoint => 'policy',
    });
}

################################################################################

1;
__END__

=head1 NAME

Net::Mattermost::API::v4::Resource::DataRetention

=head1 DESCRIPTION

=head2 USAGE

    use Net::Mattermost;

    my $mm = Net::Mattermost->new({
        authenticate => 1,
        username     => 'email@address.com',
        password     => 'passwordhere',
        base_url     => 'https://my.mattermost.server.com/api/v4/',
    });

    my $data_retention = $mm->api->v4->data_retention;

=head2 METHODS

=over 4

=item C<policy()>

    my $response = $data_retention->policy;

=back

=head1 SEE ALSO

=over 4

=item L<https://api.mattermost.com/#tag/dataretention>

Official "DataRetention" API documentation.

=back

=head1 AUTHOR

Mike Jones L<email:mike@netsplit.org.uk>

