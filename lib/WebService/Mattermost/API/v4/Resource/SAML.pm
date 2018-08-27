package WebService::Mattermost::API::v4::Resource::SAML;

use Moo;
use Types::Standard 'InstanceOf';

use WebService::Mattermost::API::v4::Resource::SAML::Certificate;
use WebService::Mattermost::Helper::Alias 'v4';

extends 'WebService::Mattermost::API::v4::Resource';

################################################################################

has certificate => (is => 'ro', isa => InstanceOf[v4 'SAML::Certificate'], lazy => 1, builder => 1);

################################################################################

sub metadata {
    my $self = shift;

    return $self->_get({
        endpoint => 'metadata',
    });
}

################################################################################

sub _build_certificate {
    my $self = shift;

    return $self->_new_related_resource('saml', 'SAML::Certificate');
}

################################################################################

1;

