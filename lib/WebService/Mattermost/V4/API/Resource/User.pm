package WebService::Mattermost::V4::API::Resource::User;

use DDP;
use Moo;

extends 'WebService::Mattermost::V4::API::Resource';
with    qw(
    WebService::Mattermost::V4::API::Resource::Role::Single
    WebService::Mattermost::V4::API::Resource::Role::View::User
);

################################################################################

around [ qw(
    get
    update
    teams
    patch
    update_roles

    generate_mfa_secret
) ] => sub {
    my $orig = shift;
    my $self = shift;
    my $id   = shift;

    return $self->validate_id($orig, $id, @_);
};

sub get {
    my $self = shift;
    my $id   = shift;

    return $self->_single_view_get({
        endpoint => '%s',
        ids      => [ $id ],
    });
}

sub update {
    my $self = shift;
    my $id   = shift;
    my $args = shift;

    return $self->_put({
        endpoint   => '%s',
        ids        => [ $id ],
        parameters => $args,
    });
}

sub teams {
    my $self = shift;
    my $id   = shift;

    print "Teams for \n";
    p $id;

    return $self->_get({
        endpoint => '%s/teams',
        ids      => [ $id ],
        view     => 'Team',
    });
}

sub deactivate {
    my $self = shift;
    my $id   = shift;

    return $self->_delete({
        endpoint => '%s',
        ids      => [ $id ],
    });
}

sub patch {
    my $self = shift;
    my $id   = shift;
    my $args = shift;

    return $self->_put({
        endpoint   => '%s/patch',
        ids        => [ $id ],
        parameters => $args,
    });
}

sub update_roles {
    my $self  = shift;
    my $id    = shift;
    my $roles = shift; # ArrayRef

    foreach my $role (@{$roles}) {
        unless (grep { $_ eq $role } @{$self->available_user_roles}) {
            my $err = sprintf('"%s" is not a valid role. Valid roles: %s',
                $role, join(', ', @{$self->available_user_roles}));

            return $self->_error_return($err);
        }
    }

    return $self->_put({
        endpoint   => '%s/roles',
        ids        => [ $id ],
        parameters => {
            roles => $roles,
        },
    });
}

sub generate_mfa_secret {
    my $self = shift;
    my $id   = shift;

    return $self->_post({
        endpoint => '%s/mfa/generate',
        ids      => [ $id ],
    });
}

################################################################################

1;
__END__

=head1 NAME

WebService::Mattermost::V4::API::Resource::User

=head1 DESCRIPTION

API methods relating to a single user by ID.

=head2 USAGE

    use WebService::Mattermost;

    my $mm = WebService::Mattermost->new({
        authenticate => 1,
        username     => 'me@somewhere.com',
        password     => 'hunter2',
        base_url     => 'https://my.mattermost.server.com/api/v4/',
    });

    my $resource = $mm->api->user;

Optionally, you can set a global user ID for the resource and not pass the ID
to every method:

    $resource->id('USER-ID-HERE');

=head2 METHODS

=over 4

=item C<get()>

L<Get a user|https://api.mattermost.com/#tag/users%2Fpaths%2F~1users~1%7Buser_id%7D%2Fget>

Get a user by their ID.

    my $response = $resource->get('USER-ID-HERE');

=item C<update()>

L<Update a user|https://api.mattermost.com/#tag/users%2Fpaths%2F~1users~1%7Buser_id%7D%2Fput>

Update a user by their ID.

    my $response = $resource->update('USER-ID-HERE', {
        # Optional arguments
        email        => '...',
        username     => '...',
        first_name   => '...',
        last_name    => '...',
        nickname     => '...',
        locale       => '...',
        position     => '...',
        props        => {
            # ...
        },
        notify_props => {
            email         => \1,
            push          => \1,
            desktop       => \1,
            desktop_sound => \1,
            mention_keys  => \1,
            channel       => \1,
            first_name    => \1,
        },
    });

=item C<teams()>

L<Get a user's teams|https://api.mattermost.com/#tag/teams%2Fpaths%2F~1users~1%7Buser_id%7D~1teams%2Fget>

=item C<deactivate()>

L<Deactivate a user account|https://api.mattermost.com/#tag/users%2Fpaths%2F~1users~1%7Buser_id%7D%2Fdelete>

Set a user as inactive by ID.

    $response->deactivate('USER-ID-HERE');

=item C<patch()>

L<Patch a user|https://api.mattermost.com/#tag/users%2Fpaths%2F~1users~1%7Buser_id%7D~1patch%2Fput>

    my $response = $resource->patch('USER-ID-HERE', {
        # Optional parameters:
        email        => '...',
        username     => '...',
        first_name   => '...',
        last_name    => '...',
        nickname     => '...',
        locale       => '...',
        position     => '...',
        props        => {
            # ...
        },
        notify_props => {
            email         => \1,
            push          => \1,
            desktop       => \1,
            desktop_sound => \1,
            mention_keys  => \1,
            channel       => \1,
            first_name    => \1,
        },
    });

=item C<update_roles()>

L<Update a user's roles|https://api.mattermost.com/#tag/users%2Fpaths%2F~1users~1%7Buser_id%7D~1roles%2Fput>

Valid roles are C<system_user> and C<system_admin>.

    my $response = $resource->update_roles('USER-ID-HERE', [
        'ROLE-NAME-HERE',
        'ANOTHER-ROLE-HERE',
    ]);

=item C<generate_mfa_secret()>

L<Generate MFA secret|https://api.mattermost.com/#tag/users%2Fpaths%2F~1users~1%7Buser_id%7D~1mfa~1generate%2Fpost>

Returns a base64 encoded QR code image.

    my $response = $resource->generate_mfa_secret('USER-ID-HERE');

=back

=head1 AUTHOR

Mike Jones L<email:mike@netsplit.org.uk>

