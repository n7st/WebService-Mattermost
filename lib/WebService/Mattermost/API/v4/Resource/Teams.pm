package WebService::Mattermost::API::v4::Resource::Teams;

use Moo;
use Types::Standard 'InstanceOf';

use WebService::Mattermost::API::v4::Resource::Teams::Channels;
use WebService::Mattermost::Helper::Alias 'v4';

extends 'WebService::Mattermost::API::v4::Resource';

################################################################################

has channels => (is => 'ro', isa => InstanceOf[v4 'Teams::Channels'], lazy => 1, builder => 1);

################################################################################

sub channel_by_name_and_team_name {
    # GET /name/{name}/channels/name/{channel_name}
}

################################################################################

sub _build_channels {
    my $self = shift;

    return $self->_new_related_resource('teams', 'Teams::Channels');
}

################################################################################

1;
__END__

=head1 NAME

WebService::Mattermost::API::v4::Resource::Teams

=head1 DESCRIPTION

=head2 USAGE

    use WebService::Mattermost;

    my $mm = WebService::Mattermost->new({
        authenticate => 1,
        username     => 'me@somewhere.com',
        password     => 'hunter2',
        base_url     => 'https://my.mattermost.server.com/api/v4/',
    });

    my $resource = $mm->api->teams;

=head2 METHODS

=over 4

=back

