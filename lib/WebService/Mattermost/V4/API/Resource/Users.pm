package WebService::Mattermost::V4::API::Resource::Users;

use Moo;
use Types::Standard qw(ArrayRef InstanceOf Str);

use WebService::Mattermost::V4::API::Resource::Users::Status;
use WebService::Mattermost::V4::API::Resource::Users::Preferences;
use WebService::Mattermost::Helper::Alias 'v4';

extends 'WebService::Mattermost::V4::API::Resource';

################################################################################

has available_user_roles => (is => 'ro', isa => ArrayRef,                            lazy => 1, builder => 1);
has status               => (is => 'ro', isa => InstanceOf[v4 'Users::Status'],      lazy => 1, builder => 1);
has preferences          => (is => 'ro', isa => InstanceOf[v4 'Users::Preferences'], lazy => 1, builder => 1);

has role_system_admin => (is => 'ro', isa => Str, default => 'system_admin');
has role_system_user  => (is => 'ro', isa => Str, default => 'system_user');

################################################################################

around [ qw(
    deactivate_by_id
    generate_mfa_secret_by_id
    get_by_id
    get_profile_image_by_id
    get_sessions_by_id
    patch_by_id
    revoke_session_by_id
    set_profile_image_by_id
    update_active_status_by_id
    update_authentication_method_by_id
    update_by_id
    update_mfa_by_id
    update_password_by_id
    update_role_by_id
) ] => sub {
    my $orig = shift;
    my $self = shift;
    my $id   = shift;

    return $self->validate_id($orig, $id, @_);
};

around [ qw(get_by_username check_mfa_by_username) ] => sub {
    my $orig     = shift;
    my $self     = shift;
    my $username = shift;

    unless ($username) {
        return $self->_error_return('Invalid or missing username parameter');
    }

    return $self->$orig($username, @_);
};

around [ qw(get_by_email send_password_reset_email) ] => sub {
    my $orig  = shift;
    my $self  = shift;
    my $email = shift;

    unless ($email) {
        return $self->_error_return('Invalid or missing email parameter');
    }

    return $self->$orig($email, @_);
};

around [ qw(
    disable_personal_access_token
    enable_personal_access_token
    get_user_access_token
) ] => sub {
    my $orig  = shift;
    my $self  = shift;
    my $token = shift;

    unless ($token) {
        return $self->_error_return('Invalid or missing token parameter');
    }

    return $self->$orig($token, @_);
};

################################################################################

sub login {
    my $self     = shift;
    my $username = shift;
    my $password = shift;

    return $self->_single_view_post({
        endpoint   => 'login',
        parameters => {
            login_id => $username,
            password => $password,
        },
        view       => 'User',
    });
}

sub search_by_email {
    my $self  = shift;
    my $email = shift;

    return $self->_get({
        endpoint => 'email/%s',
        ids      => [ $email ],
    });
}

sub create {
    my $self = shift;
    my $args = shift;

    return $self->_post({
        parameters => $args,
        required   => [ qw(username password email) ],
    });
}

sub list {
    my $self = shift;
    my $args = shift;

    return $self->_get({ parameters => $args });
}

sub list_by_ids {
    my $self = shift;
    my $ids  = shift;

    return $self->_call({
        endpoint   => 'ids',
        method     => $self->post,
        parameters => $ids,
    });
}

sub list_by_usernames {
    my $self      = shift;
    my $usernames = shift;

    return $self->_post({
        endpoint   => 'usernames',
        parameters => $usernames,
    });
}

sub search {
    my $self = shift;
    my $args = shift;

    return $self->_post({
        endpoint   => 'search',
        parameters => $args,
        required   => [ 'term' ],
    });
}

sub autocomplete {
    my $self = shift;
    my $args = shift;

    return $self->_get({
        endpoint   => 'autocomplete',
        parameters => $args,
        required   => [ 'name' ],
    });
}

sub get_by_id {
    my $self = shift;
    my $id   = shift;

    return $self->_single_view_get({
        endpoint => '%s',
        ids      => [ $id ],
        view     => 'User',
    });
}

sub update_by_id {
    my $self = shift;
    my $id   = shift;
    my $args = shift;

    return $self->_put({
        endpoint   => '%s',
        ids        => [ $id ],
        parameters => $args,
    });
}

sub update_active_status_by_id {
    my $self = shift;
    my $id   = shift;
    my $args = shift;

    return $self->_call({
        method     => $self->put,
        endpoint   => '%s/active',
        ids        => [ $id ],
        parameters => $args,
        required   => [ 'active' ],
    });
}

sub deactivate_by_id {
    my $self = shift;
    my $id   = shift;

    return $self->_delete({
        endpoint => '%s',
        ids      => [ $id ],
    });
}

sub patch_by_id {
    my $self = shift;
    my $id   = shift;
    my $args = shift;

    return $self->_put({
        endpoint   => '%s/patch',
        ids        => [ $id ],
        parameters => $args,
    });
}

sub update_role_by_id {
    my $self = shift;
    my $id   = shift;
    my $role = shift;

    unless (grep { $_ eq $role } @{$self->available_user_roles}) {
        my $err = sprintf('"%s" is not a valid role. Valid roles: %s',
            $role, join(', ', @{$self->available_user_roles}));

        return $self->_error_return($err);
    }

    return $self->_put({
        endpoint   => '%s/roles',
        ids        => [ $id ],
        parameters => {
            roles => $role,
        },
    });
}

sub get_profile_image_by_id {
    my $self = shift;
    my $id   = shift;

    return $self->_get({
        endpoint => '%s/image',
        ids      => [ $id ],
    });
}

sub set_profile_image_by_id {
    my $self     = shift;
    my $id       = shift;
    my $filename = shift;

    unless ($filename && -f $filename) {
        return $self->_error_return(sprintf('%s is not a valid file', $filename));
    }

    return $self->_post({
        endpoint           => '%s/image',
        ids                => [ $id ],
        override_data_type => 'form',
        parameters         => {
            image => { file => $filename },
        },
    });
}

sub get_by_username {
    my $self     = shift;
    my $username = shift;

    return $self->_single_view_get({
        endpoint => 'username/%s',
        view     => 'User',
        ids      => [ $username ],
    });
}

sub reset_password {
    my $self = shift;
    my $args = shift;

    return $self->_post({
        endpoint   => 'password/reset',
        parameters => $args,
        required   => [ qw(code new_password) ],
    });
}

sub update_mfa_by_id {
    my $self = shift;
    my $id   = shift;
    my $args = shift;

    return $self->_put({
        endpoint   => '%s/mfa',
        ids        => [ $id ],
        parameters => $args,
    });
}

sub generate_mfa_secret_by_id {
    my $self = shift;
    my $id   = shift;

    return $self->_post({
        endpoint => '%s/mfa/generate',
        ids      => [ $id ],
    });
}

sub check_mfa_by_username {
    my $self     = shift;
    my $username = shift;

    return $self->_post({
        endpoint   => 'mfa',
        parameters => {
            login_id => $username,
        },
    });
}

sub update_password_by_id {
    my $self = shift;
    my $id   = shift;
    my $args = shift;

    return $self->_put({
        endpoint   => '%s/password',
        ids        => [ $id ],
        parameters => $args,
    });
}

sub send_password_reset_email {
    my $self  = shift;
    my $email = shift;

    return $self->_post({
        endpoint   => 'password/reset/send',
        parameters => {
            email => $email,
        },
    });
}

sub get_by_email {
    my $self  = shift;
    my $email = shift;

    return $self->_get({
        endpoint => 'email/%s',
        ids      => [ $email ],
    });
}

sub get_sessions_by_id {
    my $self = shift;
    my $id   = shift;

    return $self->_get({
        endpoint => '%s/sessions',
        ids      => [ $id ],
    });
}

sub revoke_session_by_id {
    my $self       = shift;
    my $user_id    = shift;
    my $session_id = shift;

    return $self->_post({
        endpoint   => '%s/sessions/revoke',
        ids        => [ $user_id ],
        parameters => {
            session_id => $session_id,
        },
    });
}

sub get_user_access_token {
    my $self = shift;
    my $id   = shift;

    return $self->_get({
        endpoint => 'tokens/%s',
        ids      => [ $id ],
    });
}

sub disable_personal_access_token {
    my $self = shift;
    my $id   = shift;

    return $self->_post({
        endpoint   => 'tokens/disable',
        parameters => {
            token => $id,
        },
    });
}

sub enable_personal_access_token {
    my $self = shift;
    my $id   = shift;

    return $self->_post({
        endpoint   => 'tokens/enable',
        parameters => {
            token => $id,
        },
    });
}

sub search_tokens {
    my $self = shift;
    my $term = shift;

    return $self->_post({
        endpoint   => 'tokens/search',
        parameters => {
            term => $term,
        },
    });
}

sub update_authentication_method_by_id {
    my $self = shift;
    my $id   = shift;
    my $args = shift;

    return $self->_put({
        endpoint  => '%s/auth',
        ids       => [ $id ],
        paramters => $args,
    });
}

################################################################################

sub _build_available_user_roles {
    my $self = shift;

    return [ $self->role_system_admin, $self->role_system_user ];
}

sub _build_preferences {
    my $self = shift;

    return $self->_new_related_resource('users', 'Users::Preferences');
}

sub _build_status {
    my $self = shift;

    return $self->_new_related_resource('users', 'Users::Status');
}

################################################################################

1;
__END__

=head1 NAME

WebService::Mattermost::V4::API::Resource::Users

=head1 DESCRIPTION

=head2 USAGE

    use WebService::Mattermost;

    my $mm = WebService::Mattermost->new({
        authenticate => 1,
        username     => 'me@somewhere.com',
        password     => 'hunter2',
        base_url     => 'https://my.mattermost.server.com/api/v4/',
    });

    my $resource = $mm->api->users;

=head2 METHODS

=over 4

=item C<update_active_status_by_id()>

L<Update user active status|https://api.mattermost.com/#tag/users%2Fpaths%2F~1users~1%7Buser_id%7D~1active%2Fput>

Set a user as active or inactive.

    $resource->update_active_status_by_id('ID-HERE', {
        active => \1, # \1 for true, \0 for false
    });

=item C<deactivate_by_id>

L<Deactivate a user account|https://api.mattermost.com/#tag/users%2Fpaths%2F~1users~1%7Buser_id%7D%2Fdelete>

Set a user as inactive by ID.

    $response->deactivate_by_id('ID-HERE');

=item C<get_profile_image_by_id()>

L<Get user's profile image|https://api.mattermost.com/#tag/users%2Fpaths%2F~1users~1%7Buser_id%7D~1image%2Fget>

Get a user's profile image. Warning: returns binary content.

    my $response = $resource->get_profile_image_by_id('ID-HERE');

    # $response->raw_content contains the image as binary

=item C<set_profile_image_by_id()>

L<Set user's profile image|https://api.mattermost.com/#tag/users%2Fpaths%2F~1users~1%7Buser_id%7D~1image%2Fpost>

Set a user's profile image.

    my $response = $resource->set_profile_image_by_id('ID-HERE', '/path/to/file.jpg');

=item C<get_by_username()>

L<Get a user by username|https://api.mattermost.com/#tag/users%2Fpaths%2F~1users~1username~1%7Busername%7D%2Fget>

Get a user by their username (exact match only).

    my $response = $resource->get_by_username('mike');

=item C<reset_password_by_id()>

L<Reset password|https://api.mattermost.com/#tag/users%2Fpaths%2F~1users~1password~1reset%2Fpost>

Reset a user's password. Requires a recovery code.

    my $response = $resource->reset_password({
        new_password => 'hunter2',
        code         => 1234
    });

=item C<update_mfa_by_id()>

L<Update a user's MFA|https://api.mattermost.com/#tag/users%2Fpaths%2F~1users~1%7Buser_id%7D~1mfa%2Fput>

Set whether a user requires multi-factor auth. If the user currently has MFA
active, a code from the MFA client is required.

    my $response = $resource->update_mfa_by_id('ID-HERE', {
        activate => \1,   # or \0 for false
        code     => 1234, # required if MFA is already active
    });

=item C<generate_mfa_secret_by_id()>

L<Generate MFA secret|https://api.mattermost.com/#tag/users%2Fpaths%2F~1users~1%7Buser_id%7D~1mfa~1generate%2Fpost>

Returns a base64 encoded QR code image.

    my $response = $resource->generate_mfa_secret_by_id('ID-HERE');

=item C<get_by_id()>

L<Get a user|https://api.mattermost.com/#tag/users%2Fpaths%2F~1users~1%7Buser_id%7D%2Fget>

Get a user by their ID.

    my $response = $resource->get_by_id('ID-HERE');

=item C<update_by_id()>

L<Update a user|https://api.mattermost.com/#tag/users%2Fpaths%2F~1users~1%7Buser_id%7D%2Fput>

Update a user by their ID.

    my $response = $resource->update_by_id('ID-HERE', {
        # Optional arguments
        email        => '...',
        username     => '...',
        first_name   => '...',
        last_name    => '...',
        nickname     => '...',
        locale       => '...',
        position     => '...',
        props        => '...',
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

=item C<check_mfa_by_username()>

L<Check MFA|https://api.mattermost.com/#tag/users%2Fpaths%2F~1users~1mfa%2Fpost>

Check whether a user requires multi-factor auth by username or email.

    my $response = $resource->check_mfa_by_username('USERNAME-HERE');

=item C<update_password_by_id()>

L<Update a user's password|https://api.mattermost.com/#tag/users%2Fpaths%2F~1users~1%7Buser_id%7D~1password%2Fput>

    my $response = $resource->update_password_by_id('ID-HERE', {
        old_password => '...',
        new_password => '...',
    });

=item C<send_password_reset_email()>

L<Send password reset email|https://api.mattermost.com/#tag/users%2Fpaths%2F~1users~1password~1reset~1send%2Fpost>

Send a password reset email.

    my $response = $resource->send_password_reset_email('me@somewhere.com');

=item C<get_by_email()>

L<Get a user by email|https://api.mattermost.com/#tag/users%2Fpaths%2F~1users~1email~1%7Bemail%7D%2Fget>

Get a user by email address.

    my $response = $resource->get_by_email('me@somewhere.com');

=item C<get_sessions_by_id()>

L<Get user's sessions|https://api.mattermost.com/#tag/users%2Fpaths%2F~1users~1%7Buser_id%7D~1sessions%2Fget>

Get a user's active sessions.

    my $response = $resource->get_sessions_by_id('ID-HERE');

=item C<revoke_session_by_id()>

L<Revoke a user session|https://api.mattermost.com/#tag/users%2Fpaths%2F~1users~1%7Buser_id%7D~1sessions~1revoke%2Fpost>

Log user's session out.

    my $response = $resource->revoke_session_by_id('USER-ID-HERE', 'SESSION-ID-HERE');

=back

=head1 AUTHOR

Mike Jones L<email:mike@netsplit.org.uk>

