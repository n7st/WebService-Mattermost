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

################################################################################

1;

