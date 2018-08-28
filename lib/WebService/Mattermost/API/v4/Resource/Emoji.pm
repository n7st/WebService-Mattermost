package WebService::Mattermost::API::v4::Resource::Emoji;

use Moo;

extends 'WebService::Mattermost::API::v4::Resource';

################################################################################

around [ qw(get_by_id delete_by_id get_image_by_id) ] => sub {
    my $orig = shift;
    my $self = shift;
    my $id   = shift;

    return $self->validate_id($orig, $id, @_);
};

sub custom {
    my $self = shift;

    return $self->_get({ view => 'Emoji' });
}

sub create {
    my $self       = shift;
    my $name       = shift;
    my $filename   = shift;
    my $creator_id = shift;

    unless ($filename && -f $filename) {
        return $self->_error_return("'${filename}' is not a real file");
    }

    return $self->_single_view_post({
        view       => 'Emoji',
        parameters => {
            image => { file => $filename },
            emoji => {
                name       => $name,
                creator_id => $creator_id,
            },
        },
    });
}

sub get_by_id {
    my $self = shift;
    my $id   = shift;

    return $self->_single_view_get({
        view     => 'Emoji',
        endpoint => '%s',
        ids      => [ $id ],
    });
}

sub delete_by_id {
    my $self = shift;
    my $id   = shift;

    return $self->_single_view_delete({
        view     => 'Emoji',
        endpoint => '%s',
        ids      => [ $id ],
    });
}

sub get_by_name {
    my $self = shift;
    my $name = shift;

    unless ($name) {
        return $self->_error_return('The first argument should be an emoji name');
    }

    return $self->_single_view_get({
        view     => 'Emoji',
        endpoint => 'name/%s',
        ids      => [ $name ],
    });
}

sub get_image_by_id {
    my $self = shift;
    my $id   = shift;

    return $self->_single_view_get({
        view     => 'Emoji',
        endpoint => '%s/image',
        ids      => [ $id ],
    });
}

sub search {
    my $self = shift;
    my $args = shift;

    return $self->_post({
        view       => 'Emoji',
        endpoint   => 'search',
        parameters => $args,
        required   => [ 'term' ],
    });
}

sub autocomplete {
    my $self = shift;
    my $name = shift;

    return $self->_single_view_get({
        view       => 'Emoji',
        endpoint   => 'autocomplete',
        parameters => { name => $name },
    });
}

################################################################################

1;
__END__

=head1 NAME

WebService::Mattermost::API::v4::Resource::Emoji

=head1 DESCRIPTION

    use WebService::Mattermost;

    my $mm = WebService::Mattermost->new({
        authenticate => 1,
        username     => 'me@somewhere.com',
        password     => 'hunter2',
        base_url     => 'https://my.mattermost.server.com/api/v4/',
    });

    my $resource = $mm->api->emoji;

=head2 METHODS

=over 4

=item C<custom()>

Get all custom emojis.

    my $response = $resource->custom();

=item C<get_by_id()>

Get an emoji by its ID.

    my $response = $resource->get_by_id('EMOJI-ID-HERE');

=item C<delete_by_id()>

Delete an emoji by its ID.

    my $response = $resource->delete_by_id('EMOJI-ID-HERE');

=item C<get_by_name()>

Get an emoji by its name.

    my $response = $resource->get_by_name('EMOJI-NAME-HERE');

=item C<get_image_by_id()>

Get an emoji's image by its ID.

    my $response = $resource->get_image_by_id('EMOJI-ID-HERE');

=item C<search()>

Search custom emojis.

    my $response = $resource->search({
        # Required arguments
        term => 'Term here',

        # Optional arguments
        prefix_only => 'Prefix here',
    });

=item C<autocomplete()>

Autocomplete an emoji name.

    my $response = $resource->autocomplete('START-OF-EMOJI-NAME');

=back

=head1 SEE ALSO

=over 4

=item L<Official Emoji documentation|https://api.mattermost.com/#tag/emoji>

=back

=head1 AUTHOR

Mike Jones L<email:mike@netsplit.org.uk>

