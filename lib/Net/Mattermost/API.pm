package Net::Mattermost::API;

use Moo;
use Types::Standard qw(InstanceOf Str);

use Net::Mattermost::API::v4;

################################################################################

has base_url => (is => 'ro', isa => Str, required => 1);

has v4 => (is => 'ro', isa => InstanceOf['Net::Mattermost::API::v4'], lazy => 1, builder => 1);

################################################################################

sub _build_v4 {
    my $self = shift;

    return Net::Mattermost::API::v4->new({
        base_url => $self->base_url,
    });
}

################################################################################

1;

