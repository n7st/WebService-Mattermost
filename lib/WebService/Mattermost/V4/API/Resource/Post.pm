package WebService::Mattermost::V4::API::Resource::Post;

use Moo;

extends 'WebService::Mattermost::V4::API::Resource';
with    'WebService::Mattermost::V4::API::Resource::Role::View::Post';

################################################################################

around [ qw(
    get
    delete

    get_thread

    reactions
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

sub delete {
    my $self = shift;
    my $id   = shift;

    return $self->_single_view_delete({
        endpoint => '%s',
        ids      => [ $id ],
        view     => 'Status',
    });
}

sub get_thread {
    my $self = shift;
    my $id   = shift;

    return $self->_single_view_get({
        endpoint => '%s/thread',
        ids      => [ $id ],
        view     => 'Thread',
    });
}

sub reactions {
    my $self = shift;
    my $id   = shift;

    return $self->_get({
        endpoint => '%s/reactions',
        ids      => [ $id ],
        view     => 'Reaction',
    });
}

################################################################################

1;
__END__

=head1 NAME

WebService::Mattermost::V4::API::Resource::Post

=head1 DESCRIPTION

=head2 USAGE

    use WebService::Mattermost;

    my $mm = WebService::Mattermost->new({
        authenticate => 1,
        username     => 'email@address.com',
        password     => 'passwordhere',
        base_url     => 'https://my.mattermost.server.com/api/v4/',
    });

    my $resource = $mm->api->post;

=head2 METHODS

=over 4

=item C<get()>

L<Get a post|https://api.mattermost.com/#tag/posts%2Fpaths%2F~1posts~1%7Bpost_id%7D%2Fget>

    my $response = $resource->get('ID-HERE');

=item C<delete()>

L<Delete a post|https://api.mattermost.com/#tag/posts%2Fpaths%2F~1posts~1%7Bpost_id%7D%2Fdelete>

    my $response = $resource->delete('ID-HERE');

=item C<get_thread()>

L<Get a thread|https://api.mattermost.com/#tag/posts%2Fpaths%2F~1posts~1%7Bpost_id%7D~1thread%2Fget>

    my $response = $resource->get_thread('ID-HERE');

=item C<reactions()>

L<Get a list of reactions to a post|https://api.mattermost.com/#tag/reactions%2Fpaths%2F~1posts~1%7Bpost_id%7D~1reactions%2Fget>

    my $response = $resource->reactions('ID-HERE');

=back

=head1 AUTHOR

Mike Jones L<email:mike@netsplit.org.uk>

