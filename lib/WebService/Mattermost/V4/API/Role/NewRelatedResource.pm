package WebService::Mattermost::V4::API::Role::NewRelatedResource;

use Moo::Role;

use WebService::Mattermost::Helper::Alias 'v4';

################################################################################

sub new_related_resource {
    my $self     = shift;
    my $base     = shift;
    my $resource = shift;

    return v4($resource)->new({
        api        => $self->api,
        auth_token => $self->auth_token,
        base_url   => $self->base_url,
        resource   => $base,
    });
}

################################################################################

1;