package WebService::Mattermost::V4::API::Resource::Users::Sessions;

use Moo;

extends 'WebService::Mattermost::V4::API::Resource';

################################################################################

around [ qw(get_by_id revoke_by_id revoke_all_by_id) ] => sub {
    my $orig = shift;
    my $self = shift;
    my $id   = shift;

    return $self->validate_id($orig, $id, @_);
};

sub get_by_id {
    my $self = shift;
    my $id   = shift;

    return $self->_get({
        endpoint => '%s/sessions',
        ids      => [ $id ],
    });
}

sub revoke_by_id {
    my $self       = shift;
    my $user_id    = shift;
    my $session_id = shift;

    unless ($session_id) {
        return $self->_error_return('The second argument should be a session ID');
    }

    return $self->_post({
        endpoint   => '%s/sessions/revoke',
        ids        => [ $user_id ],
        parameters => {
            session_id => $session_id,
        },
    });
}

sub revoke_all_by_id {
    my $self = shift;
    my $id   = shift;

    return $self->_post({
        endpoint => '%s/sessions/revoke/all',
        ids      => [ $id ],
    });
}

################################################################################

1;
__END__

=head1 NAME

WebService::Mattermost::V4::API::Resource::Users::Sessions

=head1 DESCRIPTION

User sessions management.

=head2 USAGE

    use WebService::Mattermost;

    my $mm = WebService::Mattermost->new({
        authenticate => 1,
        username     => 'me@somewhere.com',
        password     => 'hunter2',
        base_url     => 'https://my.mattermost.server.com/api/v4/',
    });

    my $resource = $mm->api->users->sessions;

=head2 METHODS

=over 4

=item C<get_by_id()>

L<Get user's sessions|https://api.mattermost.com/#tag/users%2Fpaths%2F~1users~1%7Buser_id%7D~1sessions%2Fget>

Get a user's sessions by user ID.

    my $response = $resource->get_sessions_by_id('ID-HERE');

=item C<revoke_by_id()>

L<Revoke a user session|https://api.mattermost.com/#tag/users%2Fpaths%2F~1users~1%7Buser_id%7D~1sessions~1revoke%2Fpost>

Log user's session out.
    
    my $response = $resource->revoke_session_by_id('USER-ID-HERE', 'SESSION-ID-HERE');

=item C<revoke_all_by_id()>

L<Revoke all active sessions for a user|https://api.mattermost.com/#tag/users%2Fpaths%2F~1users~1%7Buser_id%7D~1sessions~1revoke~1all%2Fpost>

Revoke all of a user's active sessions.

    my $response = $resource->revoke_all_by_id('USER-ID-HERE');

=back

=head1 SEE ALSO

=over 4

=item L<Official Users documentation|https://api.mattermost.com/#tag/users>

=back

=head1 AUTHOR

Mike Jones L<email:mike@netsplit.org.uk>

