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

    return $self->_get({});
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

