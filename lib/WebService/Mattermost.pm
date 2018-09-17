package WebService::Mattermost;

use Moo;

with qw(
    WebService::Mattermost::Role::API
    WebService::Mattermost::Role::Authenticate
    WebService::Mattermost::Role::Logger
);

################################################################################

sub BUILD {
    my $self = shift;

    $self->try_authentication();

    return 1;
}

################################################################################

1;
__END__

=head1 NAME

WebService::Mattermost - a SDK for interacting with Mattermost.

=head1 DESCRIPTION

WebService::Mattermost provides websocket and REST API integrations for Mattermost.

=head2 SYNOPSIS

See C<WebService::Mattermost::API::v4> for all available API integrations.

    use WebService::Mattermost;

    my $mm = WebService::Mattermost->new({
        # Required
        base_url => 'https://my.mattermost.server.com/api/v4/',

        # Optional
        authenticate => 1, # trigger a "login" to the Mattermost server
        username     => 'MyUsername', # Login credentials for the server
        password     => 'MyPassword',
    });

    # Example REST API calls
    my $emojis = $mm->api->emoji->custom;
    my $user   = $mm->api->users->search_by_email('someone@somewhere.com');

=head2 METHODS

This class has no public methods.

=head2 ATTRIBUTES

=over 4

=item C<base_url>

The base URL of your Mattermost server. Should contain the C</api/v4/> section.

=item C<username>

An optional username for logging into Mattermost.

=item C<password>

An optional password for logging into Mattermost.

=item C<authenticate>

If this value is true, an authentication attempt will be made against your
Mattermost server.

=item C<auth_token>

Set after a successful login and used for authentication for the successive API
calls.

=item C<api>

A containing class for the available resources for API version 4.

=back

=head1 SEE ALSO

=over 4

=item L<https://api.mattermost.com/>

Plain Mattermost API documentation.

=item C<WebService::Mattermost::API::v4>

Containing object for resources for version 4 of the Mattermost REST API.
Accessible from this class via the C<api> attribute.

=back

=head1 AUTHOR

Mike Jones L<email:mike@netsplit.org.uk>

