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

################################################################################

1;

