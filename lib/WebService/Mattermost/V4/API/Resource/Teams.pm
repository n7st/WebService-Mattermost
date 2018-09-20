package WebService::Mattermost::V4::API::Resource::Teams;

use Moo;
use Types::Standard 'InstanceOf';

use WebService::Mattermost::V4::API::Resource::Teams::Channels;
use WebService::Mattermost::Helper::Alias 'v4';

extends 'WebService::Mattermost::V4::API::Resource';

################################################################################

has channels => (is => 'ro', isa => InstanceOf[v4 'Teams::Channels'], lazy => 1, builder => 1);

################################################################################

sub create {
    my $self = shift;
    my $args = shift;

    return $self->_single_view_post({
        parameters => $args,
        required   => [ qw(name display_name type) ],
    });
}

sub list {
    my $self = shift;
    my $args = shift;

    return $self->_get({
        view       => 'Team',
        parameters => $args,
    });
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

WebService::Mattermost::V4::API::Resource::Teams

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

=item C<create()>

L<Create a team|https://api.mattermost.com/#tag/teams%2Fpaths%2F~1teams%2Fpost>

    my $response = $resource->create({
        # Required parameters:
        name         => '...',
        type         => 'O', # O for open, I for invite only
        display_name => '...',
    });

=item C<list()>

L<Get teams|https://api.mattermost.com/#tag/teams%2Fpaths%2F~1teams%2Fget>

    my $response = $resource->list({
        # Optional parameters:
        page     => 0,
        per_page => 60,
    });

=back

