package WebService::Mattermost::API;

use Moo;
use Types::Standard qw(InstanceOf Str);

use WebService::Mattermost::V4::API;

################################################################################

has base_url => (is => 'ro', isa => Str, required => 1);

has v4 => (is => 'ro', isa => InstanceOf['WebService::Mattermost::V4::API'], lazy => 1, builder => 1);

################################################################################

sub _build_v4 {
    my $self = shift;

    return WebService::Mattermost::V4::API->new({
        base_url => $self->base_url,
    });
}

################################################################################

1;

