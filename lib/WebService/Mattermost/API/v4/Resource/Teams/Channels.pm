package WebService::Mattermost::API::v4::Resource::Teams::Channels;

use DDP;
use Moo;

use WebService::Mattermost::API::View::Channel;
use WebService::Mattermost::Helper::Alias 'view';

extends 'WebService::Mattermost::API::v4::Resource';

################################################################################

sub by_ids {
    my $self        = shift;
    my $team_id     = shift;
    my $channel_ids = shift;

    # TODO: test

    unless ($team_id) {
        return $self->_error_return('The first argument should be a team_id');
    }

    unless (scalar @{$channel_ids}) {
        return $self->_error_return('The second argument should be an arrayref of channel_ids');
    }

    my $response = $self->_post({
        parameters => $channel_ids,
        endpoint   => '%s/channels/ids',
        ids        => [ $team_id ],
    });

    unless ($response->is_success && ref $response->content eq 'ARRAY') {
        return $response;
    }

    return [ map { view('Channel')->new({ raw_data => $_ }) } @{$response->content} ];
}

sub public {
    my $self    = shift;
    my $team_id = shift;
    my $args    = shift;

    my $response = $self->_get({
        endpoint   => '%s/channels',
        ids        => [ $team_id ],
        parameters => $args,
    });

    unless ($response->is_success && ref $response->content eq 'ARRAY') {
        return $response;
    }

    return [ map { view('Channel')->new({ raw_data => $_ }) } @{$response->content} ];
}

sub deleted {
    my $self    = shift;
    my $team_id = shift;
    my $args    = shift;

    return $self->_get({
        endpoint   => '%s/channels/deleted',
        ids        => [ $team_id ],
        parameters => $args,
    });
}

sub autocomplete {
    my $self    = shift;
    my $team_id = shift;
    my $args    = shift;

    return $self->_get({
        endpoint   => '%s/channels/autocomplete',
        ids        => [ $team_id ],
        parameters => $args,
        required   => [ 'name' ],
    });
}

sub search {
    my $self    = shift;
    my $team_id = shift;
    my $args    = shift;

    return $self->_post({
        endpoint   => '%s/channels/search',
        ids        => [ $team_id ],
        parameters => $args,
        required   => [ 'term' ],
    });
}

sub by_name {
    my $self    = shift;
    my $team_id = shift;
    my $name    = shift;

    return $self->_get({
        endpoint => '%s/channels/name/%s',
        ids      => [ $team_id, $name ],
    });
}

sub by_name_and_team_name {
    my $self         = shift;
    my $team_name    = shift;
    my $channel_name = shift;

    return $self->_get({
        endpoint => 'name/%s/channels/name/%s',
        ids      => [ $team_name, $channel_name ],
    });
}

################################################################################

1;
__END__

=head1 NAME

WebService::Mattermost::API::v4::Resource::Teams::Channels

=head1 DESCRIPTION

=head2 USAGE

    use WebService::Mattermost;

    my $mm = WebService::Mattermost->new({
        authenticate => 1,
        username     => 'me@somewhere.com',
        password     => 'hunter2',
        base_url     => 'https://my.mattermost.server.com/api/v4/',
    });

    my $resource = $mm->api->teams->channels;

=head2 METHODS

=over 4

=item C<by_ids()>

L<Get a list of channels by IDs|https://api.mattermost.com/#tag/channels%2Fpaths%2F~1teams~1%7Bteam_id%7D~1channels~1ids%2Fpost>

    my $response = $resource->get_by_ids('team-id-here', [ qw(
        first_channel_id
        second_channel_id
        third_channel_id
    ) ]);

=item C<public()>

L<Get public channels|https://api.mattermost.com/#tag/channels%2Fpaths%2F~1teams~1%7Bteam_id%7D~1channels%2Fget>

    my $response = $resource->public('team-id-here', {
        # Optional arguments
        page     => 1,
        per_page => 60,
    });

=item C<deleted()>

L<Get deleted channels|https://api.mattermost.com/#tag/channels%2Fpaths%2F~1teams~1%7Bteam_id%7D~1channels~1deleted%2Fget>

    my $response = $resource->deleted('team-id-here', {
        # Optional arguments
        page     => 1,
        per_page => 60,
    });

=item C<autocomplete()>

L<Autocomplete channels|https://api.mattermost.com/#tag/channels%2Fpaths%2F~1teams~1%7Bteam_id%7D~1channels~1autocomplete%2Fget>

    my $response = $resource->autocomplete('team-id-here', {
        # Required arguments
        name => 'Something',
    });

=item C<search()>

L<Search channels|https://api.mattermost.com/#tag/channels%2Fpaths%2F~1teams~1%7Bteam_id%7D~1channels~1search%2Fpost>

    my $response = $resource->search('team-id-here', {
        # Required arguments
        term => 'Something',
    });

=back

=head1 AUTHOR

Mike Jones L<email:mike@netsplit.org.uk>

