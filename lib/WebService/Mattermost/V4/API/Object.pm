package WebService::Mattermost::V4::API::Object;

use DateTime;
use Moo;
use Types::Standard qw(HashRef InstanceOf Str);

use WebService::Mattermost::V4::API;

################################################################################

has [ qw(auth_token base_url) ] => (is => 'ro', isa => Str,     required => 1);
has raw_data                    => (is => 'ro', isa => HashRef, required => 1);

has api => (is => 'ro', isa => InstanceOf['WebService::Mattermost::V4::API'], lazy => 1, builder => 1);

################################################################################

sub _from_epoch {
    my $self           = shift;
    my $unix_timestamp = shift;

    return undef unless $unix_timestamp;

    # The timestamp is too precise - trim away the end
    $unix_timestamp =~ s/...$//s;

    return DateTime->from_epoch(epoch => $unix_timestamp);
}

################################################################################

sub _build_api {
    my $self = shift;

    return WebService::Mattermost::V4::API->new({
        auth_token => $self->auth_token,
        base_url   => $self->base_url,
    });
}

################################################################################

1;

