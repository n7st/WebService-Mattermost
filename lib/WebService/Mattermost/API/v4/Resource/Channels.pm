package WebService::Mattermost::API::v4::Resource::Channels;

use DDP;
use List::Util 'first';
use Moo;

extends 'WebService::Mattermost::API::v4::Resource';

################################################################################

sub create {
    my $self = shift;
    my $args = shift;

    $args->{type} = uc $args->{type} if $args->{type};

    # O for public, P for private
    if (!$args->{type} || !first { $_ eq $args->{type} } qw(O P)) {
        return $self->_error_return('"type" must be O or P');
    }

    return $self->_post({
        parameters => $args,
        required   => [ qw(team_id name display_name type) ],
    });
}

sub create_direct_channel {
    my $self     = shift;
    my $user_ids = shift;

    if (scalar @{$user_ids} != 2) {
        return $self->_error_return('Two user IDs must be passed');
    }

    return $self->_post({
        endpoint   => 'direct',
        parameters => $user_ids,
    });
}

sub create_group_channel {
    my $self     = shift;
    my $user_ids = shift;

    if (scalar @{$user_ids} < 2) {
        return $self->_error_return('At least two user IDs must be passed');
    }

    return $self->_post({
        endpoint   => 'group',
        parameters => $user_ids,
    });
}

sub get {
    # GET /{id}
}

sub update {
    # PUT /{id}
}

sub delete {
    # DELETE /{id}
}

sub patch {
    # PUT /{id}/patch
}

sub convert {
    # POST /{id}/convert
}

sub restore {
    # POST /{id}/restore
}

sub stats {
    # GET /{id}/stats
}

sub pinned {
    # GET /{id}/pinned
}

sub members {
    # GET /{id}/members
}

sub add_member {
    # POST /{id}/members
}

sub members_by_ids {
    # POST /{id}/members/ids
}

sub member_by_id {
    # GET /{id}/members/{user_id}
}

sub remove_member {
    # DELETE /{id}/members/{user_id}
}

sub update_roles {
    # PUT /{id}/members/{user_ids}/roles
}

################################################################################

1;
__END__

=head1 NAME

WebService::Mattermost::API::v4::Resource::Channels

=head1 DESCRIPTION

=head2 USAGE

    use WebService::Mattermost;

    my $mm = WebService::Mattermost->new({
        authenticate => 1,
        username     => 'me@somewhere.com',
        password     => 'hunter2',
        base_url     => 'https://my.mattermost.server.com/api/v4/',
    });

    my $resource = $mm->api->channels;

=head2 METHODS

=over 4

=item C<create()>

L<Create a channel|https://api.mattermost.com/#tag/channels%2Fpaths%2F~1channels%2Fpost>

Create a public or private channel.

    my $response = $resource->create({
        # Required arguments
        type         => 'P', # P for private, O for public
        team_id      => '1234abcd',
        name         => 'my-new-channel',
        display_name => 'MyNewChannel',

        # Optional arguments
        purpose => 'A channel for testing',
        header  => 'Channel topic',
    });

=item C<create_direct_channel()>

L<Create a direct message channel|https://api.mattermost.com/#tag/channels%2Fpaths%2F~1channels~1direct%2Fpost>

Create a direct message channel between two users. Two user IDs must be
provided.

    my $response = $resource->create_direct_channel([ qw(
        user_1_id_here
        user_2_id_here
    ) ]);

=item C<create_group_channel()>

L<Create a group message channel|https://api.mattermost.com/#tag/channels%2Fpaths%2F~1channels~1group%2Fpost>

Create a direct message channel between two users. Two user IDs must be
provided.

    my $response = $resource->create_group_channel([ qw(
        user_1_id_here
        user_2_id_here
        user_3_id_here
    ) ]);

=back

=head1 AUTHOR

Mike Jones L<email:mike@netsplit.org.uk>

