package Net::Mattermost::Role::UserAgent;

use Moo::Role;
use Types::Standard 'InstanceOf';

use Net::Mattermost::Util::UserAgent;
use Net::Mattermost::Helper::Alias 'util';

################################################################################

has ua => (is => 'ro', isa => InstanceOf['Mojo::UserAgent'], lazy => 1, builder => 1);

################################################################################

sub _build_ua {
    return util('UserAgent')->new->ua;
}

################################################################################

1;

