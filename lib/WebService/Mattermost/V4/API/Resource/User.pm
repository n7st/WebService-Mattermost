package WebService::Mattermost::V4::API::Resource::User;

use Moo;

extends 'WebService::Mattermost::V4::API::Resource';
with    qw(
    WebService::Mattermost::V4::API::Resource::Role::Single
    WebService::Mattermost::V4::API::Resource::Role::View::User
);

################################################################################

around [ qw(teams) ] => sub {
    my $orig = shift;
    my $self = shift;
    my $id   = shift;

    return $self->validate_id($orig, $id, @_);
};

sub teams {
    my $self = shift;
    my $id   = shift;

    return $self->_get({
        endpoint => '%s/teams',
        ids      => [ $id ],
        view     => 'Team',
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

=item C<teams()>

L<Get a user's teams|https://api.mattermost.com/#tag/teams%2Fpaths%2F~1users~1%7Buser_id%7D~1teams%2Fget>

=back

=head1 AUTHOR

Mike Jones L<email:mike@netsplit.org.uk>

