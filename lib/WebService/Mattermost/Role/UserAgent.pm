package WebService::Mattermost::Role::UserAgent;

use Moo::Role;
use Types::Standard 'InstanceOf';

use WebService::Mattermost::Util::UserAgent;
use WebService::Mattermost::Helper::Alias 'util';

################################################################################

has ua => (is => 'ro', isa => InstanceOf['Mojo::UserAgent'], lazy => 1, builder => 1);

################################################################################

sub mmauthtoken {
    my $self  = shift;
    my $token = shift;

    return sprintf('MMAUTHTOKEN=%s', $token);
}

sub bearer {
    my $self  = shift;
    my $token = shift;

    return sprintf('Bearer %s', $token);
}

################################################################################

sub _build_ua {
    return util('UserAgent')->new->ua;
}

################################################################################

1;

