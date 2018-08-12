package Net::Mattermost;

use Carp 'croak';
use Moo;
use Types::Standard qw(Bool InstanceOf Str);

use Net::Mattermost::API;

################################################################################

has username => (is => 'ro', isa => Str, required => 0);
has password => (is => 'ro', isa => Str, required => 0);
has base_url => (is => 'ro', isa => Str, required => 1);

has authenticate => (is => 'ro', isa => Bool, default => 0);
has auth_token   => (is => 'rw', isa => Str,  default => '');
has api_version  => (is => 'ro', isa => Str,  default => 'v4');

has api => (is => 'ro', isa => InstanceOf['Net::Mattermost::API'], lazy => 1, builder => 1);

################################################################################

sub BUILD {
    my $self = shift;

    if ($self->authenticate && $self->username && $self->password) {
        my $ver = $self->api_version;

        # Log into Mattermost at runtime. The entire API requires an auth token
        # which is sent back from the login method.
        my $ret = $self->api->$ver->users->login($self->username, $self->password);

        if ($ret->is_success) {
            $self->auth_token($ret->headers->header('Token'));
            $self->_set_resource_auth_token();
        } else {
            croak $ret->message;
        }
    } elsif ($self->auth_token) {
        $self->_set_resource_auth_token();
    }

    return 1;
}

################################################################################

sub _set_resource_auth_token {
    my $self  = shift;

    my $ver = $self->api_version;

    # Set the auth token against every available resource class after a
    # successful login to the Mattermost server
    foreach my $resource (@{$self->api->$ver->resources}) {
        $resource->auth_token($self->auth_token);
    }

    return 1;
}

################################################################################

sub _build_api {
    my $self = shift;

    return Net::Mattermost::API->new({ base_url => $self->base_url });
}

################################################################################

1;
__END__

=head1 NAME

Net::Mattermost - a SDK for interacting with Mattermost.

=head1 DESCRIPTION

Net::Mattermost provides websocket and REST API integrations for Mattermost.

=head2 SYNOPSIS

See C<Net::Mattermost::API::v4> for all available API integrations.

    use Net::Mattermost;

    my $mm = Net::Mattermost->new({
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

=item C<Net::Mattermost::API::v4>

Containing object for resources for version 4 of the Mattermost REST API.
Accessible from this class via the C<api> attribute.

=back

=head1 AUTHOR

Mike Jones L<email:mike@netsplit.org.uk>

