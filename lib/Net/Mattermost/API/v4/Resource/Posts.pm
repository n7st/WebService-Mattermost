package Net::Mattermost::API::v4::Resource::Posts;

use Moo;

extends 'Net::Mattermost::API::v4::Resource';

################################################################################

sub reactions_for_id {
    my $self = shift;
    my $id   = shift;

    return $self->_call({
        method   => $self->get,
        endpoint => '%s/reactions',
        ids      => [ $id ],
    });
}

################################################################################

1;
__END__

=head1 NAME

Net::Mattermost::API::v4::Resource::Posts

=head1 DESCRIPTION

=head2 USAGE

    use Net::Mattermost;

    my $mm = Net::Mattermost->new({
        authenticate => 1,
        username     => 'email@address.com',
        password     => 'passwordhere',
        base_url     => 'https://my.mattermost.server.com/api/v4/',
    });

    my $posts = $mm->api->v4->posts;

=head2 METHODS

=over 4

=item C<reactions_for_id()>

Get reactions for a message by ID.

    my $response = $posts->reactions_for_id('idhere');

=back

=head1 SEE ALSO

=over 4

=item L<https://api.mattermost.com/#tag/posts>

Official "posts" API documentation.

=back

=head1 AUTHOR

Mike Jones L<email:mike@netsplit.org.uk>

