package WebService::Mattermost::V4::API::Resource::IntegrationActions;

# ABSTRACT: Wrapped API methods for the integration actions API endpoints.

use Moo;

extends 'WebService::Mattermost::V4::API::Resource';

################################################################################

sub open {
    my $self = shift;
    my $args = shift;

    return $self->_post({
        endpoint   => 'dialogs/open',
        parameters => $args,
        required   => [ qw(trigger_id url dialog) ],
        view       => 'Status',
    });
}

sub submit {
    my $self = shift;
    my $args = shift;

    return $self->_post({
        endpoint   => 'dialogs/submit',
        parameters => $args,
        required   => [ qw(url channel_id team_id submission) ],
    });
}

################################################################################

1;
__END__

=head1 DESCRIPTION

Wrapped API methods for the integration actions endpoints.

=head2 USAGE

    use WebService::Mattermost;

    my $mm = WebService::Mattermost->new({
        authenticate => 1,
        username     => 'email@address.com',
        password     => 'passwordhere',
        base_url     => 'https://my.mattermost.server.com/api/v4/',
    });

    my $resource = $mm->api->integration_actions;

=head2 METHODS

=over 4

=item C<open()>

L<Open a dialog|https://api.mattermost.com/#tag/integration_actions/operation/OpenInteractiveDialog>

    my $response = $resource->open({
        # Required parameters:
        trigger_id => 'TRIGGER-ID-HERE',
        url        => '...',
        dialog     => {
            # See Mattermost API documentation (above) for payload
        },
    });

=item C<create()>

L<Submit a dialog|https://api.mattermost.com/#tag/integration_actions/operation/SubmitInteractiveDialog>

    my $response = $resource->create({
        # Required parameters:
        url        => '...',
        channel_id => 'CHANNEL-ID-HERE',
        team_id    => 'TEAM-ID-HERE',
        submission => {
            # See Mattermost API documentation (above) for payload
        },

        # Optional parameters
        callback_id => 'CALLBACK-ID-HERE',
        state       => '...',
        cancelled   => 1, # Boolean, 1 or 0
    });

=back
