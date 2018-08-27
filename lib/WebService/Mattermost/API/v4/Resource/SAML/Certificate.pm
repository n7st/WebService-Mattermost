package WebService::Mattermost::API::v4::Resource::SAML::Certificate;

use Moo;

extends 'WebService::Mattermost::API::v4::Resource';

################################################################################

sub status {
    my $self = shift;

    return $self->_get({ endpoint => 'status' });
}

sub idp_upload {
    my $self     = shift;
    my $filename = shift;

    # TODO: wrapping helper for filenames (here and Resource::Users)

    return $self->_post({
        endpoint   => 'idp',
        parameters => {
            certificate => { file => $filename },
        },
    });
}

sub idp_remove {
    my $self = shift;

    return $self->_delete({ endpoint => 'idp' });
}

sub public_upload {
    my $self     = shift;
    my $filename = shift;

    # TODO: wrapping helper for filenames (here and Resource::Users)

    return $self->_post({
        endpoint   => 'public',
        parameters => {
            certificate => { file => $filename },
        },
    });
}

sub public_remove {
    my $self = shift;

    return $self->_delete({ endpoint => 'public' });
}

sub private_upload {
    my $self     = shift;
    my $filename = shift;

    # TODO: wrapping helper for filenames (here and Resource::Users)

    return $self->_post({
        endpoint   => 'private',
        parameters => {
            certificate => { file => $filename },
        },
    });
}

sub private_remove {
    my $self = shift;

    return $self->_delete({ endpoint => 'private' });
}

################################################################################

1;

