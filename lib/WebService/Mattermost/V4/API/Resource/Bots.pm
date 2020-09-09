package WebService::Mattermost::V4::API::Resource::Bots;

# ABSTRACT: Wrapped API methods for the bots API endpoints.

use Moo;

extends 'WebService::Mattermost::V4::API::Resource';
with    'WebService::Mattermost::V4::API::Resource::Role::View::Bot';

################################################################################

around [ qw(get) ] => sub {
    my $orig = shift;
    my $self = shift;
    my $id   = shift;

    return $self->validate_id($orig, $id, @_);
};

sub get {
    my $self = shift;
    my $id   = shift;
    my $args = shift;

    return $self->_single_view_get({
        endpoint   => '%s',
        ids        => [ $id ],
        parameters => $args,
    });
}

sub list {
    my $self = shift;
    my $args = shift;

    return $self->_get({ parameters => $args });
}

################################################################################

1;
__END__

=head1 DESCRIPTION

=head2 USAGE

    use WebService::Mattermost;

    my $mm = WebService::Mattermost->new({
        authenticate => 1,
        username     => 'me@somewhere.com',
        password     => 'hunter2',
        base_url     => 'https://my.mattermost.server.com/api/v4/',
    });

    my $resource = $mm->api->bots;

=head2 METHODS

=over 4

=item * C<get()>

L<Get a bot|https://api.mattermost.com/#tag/bots/paths/~1bots~1{bot_user_id}/get>

    my $response = $resource->get('ID-HERE');

Allow the search to include a deleted bot:

    my $response = $resource->get('ID-HERE', {
        include_deleted => 1,
    });

=item * C<list()>

L<Get bots|https://api.mattermost.com/#tag/bots/paths/~1bots/get>

    my $response = $resource->list();

With optional parameters:

    my $response = $resource->list({
        include_deleted => 1,
        only_orphaned   => 1,
        page            => 0,
        per_page        => 60,
    });

=back

