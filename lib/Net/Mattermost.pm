package Net::Mattermost;

use DDP;
use Moo;
use Types::Standard qw(Bool InstanceOf Str);

use Net::Mattermost::API::v4;
use Net::Mattermost::WS::v4;

################################################################################

has username => (is => 'ro', isa => Str, required => 0);
has password => (is => 'ro', isa => Str, required => 0);
has base_url => (is => 'ro', isa => Str, required => 1);

has authenticate => (is => 'ro', isa => Bool, default => 0);
has auth_token   => (is => 'rw', isa => Str,  default => '');

has api => (is => 'ro', isa => InstanceOf['Net::Mattermost::API::v4'], lazy => 1, builder => 1);
has ws  => (is => 'ro', isa => InstanceOf['Net::Mattermost::WS::v4'],  lazy => 1, builder => 1);

################################################################################

sub BUILD {
    my $self = shift;

    # Log into Mattermost at runtime. The entire API requires an auth token
    # which is sent back from the login method.
    if ($self->authenticate && $self->username && $self->password) {
        my $ret = $self->api->users->login($self->username, $self->password);

        if ($ret->is_success) {
            $self->auth_token($ret->headers->header('Token'));

            foreach my $resource (@{$self->api->resources}) {
                p $resource->resource;
                $resource->auth_token($self->auth_token);
            }
        } else {
            p $ret;
        }
    }

    return 1;
}

################################################################################

sub _build_api {
    my $self = shift;

    return Net::Mattermost::API::v4->new({
        base_url => $self->base_url,
    });
}

sub _build_ws {
    my $self = shift;

    return Net::Mattermost::WS::v4->new();
}

################################################################################

1;
