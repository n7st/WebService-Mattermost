package WebService::Mattermost::V4::API::Resource::DataRetention;

# ABSTRACT: Wrapped API methods for the data retention API endpoints.

use Moo;
use Types::Standard 'Str';

extends 'WebService::Mattermost::V4::API::Resource';

################################################################################

has view_name => (is => 'ro', isa => Str, default => 'DataRetentionPolicy');

################################################################################

sub policy {
    my $self = shift;

    return $self->_get({ endpoint => 'policy' });
}

################################################################################

1;
__END__

=head1 DESCRIPTION

=head2 USAGE

    use WebService::Mattermost;

    my $mm = WebService::Mattermost->new({
        authenticate => 1,
        username     => 'email@address.com',
        password     => 'passwordhere',
        base_url     => 'https://my.mattermost.server.com/api/v4/',
    });

    my $data_retention = $mm->api->data_retention;

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
