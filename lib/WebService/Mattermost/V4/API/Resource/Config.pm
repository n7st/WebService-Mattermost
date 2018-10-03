package WebService::Mattermost::V4::API::Resource::Config;

use Moo;
use Types::Standard 'Str';

extends 'WebService::Mattermost::V4::API::Resource';

################################################################################

has view_name => (is => 'ro', isa => Str, default => 'Config');

################################################################################

sub get {
    my $self = shift;

    return $self->_single_view_get();
}

################################################################################

1;
__END__

=head1 NAME

WebService::Mattermost::V4::API::Resource::Config

=head1 DESCRIPTION

=head2 USAGE

    use WebService::Mattermost;

    my $mm = WebService::Mattermost->new({
        authenticate => 1,
        username     => 'me@somewhere.com',
        password     => 'hunter2',
        base_url     => 'https://my.mattermost.server.com/api/v4/',
    });

    my $resource = $mm->api->config;

=head2 METHODS

=over 4

=item C<get()>

L<Get configuration|https://api.mattermost.com/#tag/system%2Fpaths%2F~1file~1s3_test%2Fpost>

    my $response = $resource->get();

=back

=head1 AUTHOR

Mike Jones L<email:mike@netsplit.org.uk>

