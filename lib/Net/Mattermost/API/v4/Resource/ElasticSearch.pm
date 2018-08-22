package Net::Mattermost::API::v4::Resource::ElasticSearch;

use Moo;

extends 'Net::Mattermost::API::v4::Resource';

################################################################################

sub test {
    my $self = shift;

    return $self->_post({ endpoint => 'test' });
}

sub purge_indexes {
    my $self = shift;

    return $self->_post({ endpoint => 'purge' });
}

################################################################################

1;
__END__

=head1 NAME

Net::Mattermost::API::v4::Resource::ElasticSearch

=head1 DESCRIPTION

=head2 USAGE

    use Net::Mattermost;

    my $mm = Net::Mattermost->new({
        authenticate => 1,
        username     => 'email@address.com',
        password     => 'passwordhere',
        base_url     => 'https://my.mattermost.server.com/api/v4/',
    });

    my $elasticsearch = $mm->api->v4->elasticsearch;

=head2 METHODS

=over 4

=item C<test()>

    my $response = $elasticsearch->test;

=item C<purge_indexes()>

    my $response = $elasticsearch->purge_indexes;

=back

=head1 SEE ALSO

=over 4

=item L<https://api.mattermost.com/#tag/elasticsearch>

Official "ElasticSearch" API documentation.

=back

=head1 AUTHOR

Mike Jones L<email:mike@netsplit.org.uk>

