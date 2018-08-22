package Net::Mattermost::API::v4::Resource::Cluster;

use Moo;

extends 'Net::Mattermost::API::v4::Resource';

################################################################################

sub status {
    my $self = shift;

    return $self->_get({ endpoint => 'status' });
}

################################################################################

1;
__END__

=head1 NAME

Net::Mattermost::API::v4::Resource::Cluster

=head1 DESCRIPTION

=head2 USAGE

    use Net::Mattermost;

    my $mm = Net::Mattermost->new({
        authenticate => 1,
        username     => 'email@address.com',
        password     => 'passwordhere',
        base_url     => 'https://my.mattermost.server.com/api/v4/',
    });

    my $cluster = $mm->api->v4->cluster;

=head2 METHODS

=over 4

=item C<status()>

    my $response = $cluster->status;

=back

=head1 SEE ALSO

=over 4

=item L<https://api.mattermost.com/#tag/cluster>

Official "cluster" API documentation.

=back

=head1 AUTHOR

Mike Jones L<email:mike@netsplit.org.uk>

