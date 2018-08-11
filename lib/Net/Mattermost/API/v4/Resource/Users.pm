package Net::Mattermost::API::v4::Resource::Users;

use Moo;

extends 'Net::Mattermost::API::v4::Resource';

################################################################################

sub login {
    my $self     = shift;
    my $username = shift;
    my $password = shift;

    return $self->_call({
        method     => $self->post,
        endpoint   => 'login',
        parameters => {
            login_id => $username,
            password => $password,
        },
    });
}

sub search_by_email {
    my $self  = shift;
    my $email = shift;

    return $self->_call({
        method   => $self->get,
        endpoint => 'email/%s',
        ids      => [ $email ],
    });
}

sub create {
    my $self = shift;
    my $args = shift;

    return $self->_call({
        method     => $self->post,
        parameters => $args,
        required   => [ qw(username password email) ],
    });
}

sub list {
    my $self = shift;
    my $args = shift;

    return $self->_call({
        method     => $self->get,
        parameters => $args,
    });
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

    return $self->_call({
        endpoint   => 'usernames',
        method     => $self->post,
        parameters => $usernames,
    });
}

sub search {
    my $self = shift;
    my $args = shift;

    return $self->_call({
        endpoint   => 'search',
        method     => $self->post,
        parameters => $args,
        required   => [ 'term' ],
    });
}

sub autocomplete {
    my $self = shift;
    my $args = shift;

    return $self->_call({
        endpoint   => 'autocomplete',
        method     => $self->get,
        parameters => $args,
        required   => [ 'name' ],
    });
}

sub get_by_id {
    my $self = shift;
    my $id   = shift;

    return $self->_call({
        method   => $self->get,
        endpoint => '%s',
        ids      => [ $id ],
    });
}

sub update {
    my $self = shift;
    my $id   = shift;
    my $args = shift;

    unless ($id) {
        # TODO: return error
    }

    return $self->_call({
        method     => $self->put,
        endpoint   => '%s',
        ids        => [ $id ],
        parameters => $args,
    });
}

################################################################################

1;

