package WebService::Mattermost::V4::API::Resource::WebRTC;

# ABSTRACT: Wrapped API methods for the WebRTC API endpoints.

use Moo;

extends 'WebService::Mattermost::V4::API::Resource';

################################################################################

sub get_token {
    my $self = shift;

    return $self->_single_view_get({
        endpoint => 'token',
        view     => 'WebRTCToken',
    });
}

################################################################################

1;
__END__

=head1 DESCRIPTION

B<This API endpoint was removed from Mattermost in version v5.6 (October 2018).
As such, the methods in this class will not do anything when used with recent
versions of Mattermost!>

=head2 USAGE

    use WebService::Mattermost;

    my $mm = WebService::Mattermost->new({
        authenticate => 1,
        username     => 'me@somewhere.com',
        password     => 'hunter2',
        base_url     => 'https://my.mattermost.server.com/api/v4/',
    });

    my $resource = $mm->api->webrtc;

=head2 METHODS

=over 4

=item C<get_token()>

L<Get WebRTC token|https://api.mattermost.com/#tag/system%2Fpaths%2F~1webrtc~1token%2Fget>

    my $response = $resource->get_token();

=back
