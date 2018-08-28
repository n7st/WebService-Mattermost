package WebService::Mattermost::API::v4::Resource::Files;

use Moo;

extends 'WebService::Mattermost::API::v4::Resource';

################################################################################

around [ qw(upload get get_thumbnail get_preview get_link get_metadata) ] => sub {
    my $orig = shift;
    my $self = shift;
    my $id   = shift;

    return $self->validate_id($orig, $id, @_);
};

sub upload {
    my $self       = shift;
    my $channel_id = shift;
    my $filename   = shift;

    return $self->_post({
        parameters => {
            channel_id => $channel_id,
            files      => { file => $filename },
        },
    });
}

sub get {
    my $self    = shift;
    my $file_id = shift;

    return $self->_get({
        endpoint => '%s',
        ids      => [ $file_id ],
    });
}

sub get_thumbnail {
    my $self    = shift;
    my $file_id = shift;

    return $self->_get({
        endpoint => '%s/thumbnail',
        ids      => [ $file_id ],
    });
}

sub get_preview {
    my $self    = shift;
    my $file_id = shift;

    return $self->_get({
        endpoint => '%s/preview',
        ids      => [ $file_id ],
    });
}

sub get_link {
    my $self    = shift;
    my $file_id = shift;

    return $self->_get({
        endpoint => '%s/link',
        ids      => [ $file_id ],
    });
}

sub get_metadata {
    my $self    = shift;
    my $file_id = shift;

    return $self->_get({
        endpoint => '%s/info',
        ids      => [ $file_id ],
    });
}

################################################################################

1;
__END__

=head1 NAME

WebService::Mattermost::API::v4::Resource::Files

=head1 DESCRIPTION

=head2 USAGE

    use WebService::Mattermost;

    my $mm = WebService::Mattermost->new({
        authenticate => 1,
        username     => 'me@somewhere.com',
        password     => 'hunter2',
        base_url     => 'https://my.mattermost.server.com/api/v4/',
    });

    my $resource = $mm->api->files;

=head2 METHODS

=over 4

=item C<upload()>

Upload a file to a channel.

    $resource->upload('CHANNEL_ID_HERE', '/path/to/filename.txt');

=item C<get()>

Get basic information about a file.

    $resource->get('FILE_ID_HERE');

=item C<get_thumbnail()>

Get a file's thumbnail

    $resource->get_thumbnail('FILE_ID_HERE');

=item C<get_preview()>

Get a file's preview.

    $resource->get_preview('FILE_ID_HERE');

=item C<get_link()>

Get a public link to a file.

    $resource->get_link('FILE_ID_HERE');

=item C<get_metadata()>

Get information about a file.

    $resource->get_metadata('FILE_ID_HERE');

=back

=head1 SEE ALSO

=over 4

=item L<Official Files documentation|https://api.mattermost.com/#tag/files>

=back
