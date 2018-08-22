package WebService::Mattermost::Role::Authenticate;

use Moo::Role;
use Types::Standard qw(Bool Str);

requires qw(api logger);

################################################################################

has [ qw(username password) ] => (is => 'ro', isa => Str, required => 1);

has [ qw(auth_token user_id) ] => (is => 'rw', isa => Str,  default => '');
has authenticate               => (is => 'rw', isa => Bool, default => 0);

################################################################################

sub try_authentication {
    my $self = shift;

    if ($self->authenticate && $self->username && $self->password) {
        # Log into Mattermost at runtime. The entire API requires an auth token
        # which is sent back from the login method.
        my $ret = $self->api->users->login($self->username, $self->password);

        if ($ret->is_success) {
            $self->auth_token($ret->headers->header('Token'));
            $self->user_id($ret->content->{id});
            $self->_set_resource_auth_token();
        } else {
            $self->logger->logdie($ret->message);
        }
    } elsif ($self->authenticate && !($self->username && $self->password)) {
        $self->logger->logdie('"username" and "password" are required attributes for authentication');
    } elsif ($self->auth_token) {
        $self->_set_resource_auth_token();
    }

    return 1;
}

################################################################################

sub _set_resource_auth_token {
    my $self  = shift;

    # Set the auth token against every available resource class after a
    # successful login to the Mattermost server
    foreach my $resource (@{$self->api->resources}) {
        $resource->auth_token($self->auth_token);
    }

    return 1;
}

################################################################################

1;
__END__

=head1 NAME

WebService::Mattermost::Role::Authenticate - log in to a Mattermost server.

=head1 DESCRIPTION

Require in classes which should automatically authenticate against the API.

=head2 USAGE

    package SomePackage {
        use Moo;

        # Requires the API and logger roles, too
        with qw(
            WebService::Mattermost::Role::API
            WebService::Mattermost::Role::Authenticate
            WebService::Mattermost::Role::Logger
        );

        sub BUILD {
            my $self = shift;

            $self->try_authentication();

            return 1;
        }

        1;
    }

    SomePackage->new({
        base_url     => 'https://my.mattermost.server.com/api/v4/',
        username     => 'usernamehere',
        password     => 'passwordhere',
        authenticate => 1,
    });

=head2 METHODS

=over 4

=item C<try_authentication()>

Attempts to connect to the server with the given credentials.

=back

=head2 ATTRIBUTES

=over 4

=item C<username>

=item C<password>

=item C<api_version>

Defaults to C<v4>.

=item C<authenticate>

Defaults to false.

=item C<auth_token>

Set on authentication. Allows future calls to the API.

=item C<user_id>

Set on authentication.

=back

=head1 AUTHOR

Mike Jones L<email:mike@netsplit.org.uk>

