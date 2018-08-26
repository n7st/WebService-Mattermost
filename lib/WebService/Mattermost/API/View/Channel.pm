package WebService::Mattermost::API::View::Channel;

use DDP;
use Moo;
use Types::Standard qw(HashRef InstanceOf Int Maybe Str);

use WebService::Mattermost::Helper::Alias 'view';

extends 'WebService::Mattermost::API::View';

################################################################################

has [ qw(
    created_at
    delete_at
    extra_updated_at
    last_post_at
    updated_at
) ] => (is => 'ro', isa => Maybe[InstanceOf['DateTime']], lazy => 1, builder => 1);

has [ qw(
    creator_id
    display_name
    header
    id
    name
    purpose
    team_id
    type
) ] => (is => 'ro', isa => Maybe[Str], lazy => 1, builder => 1);

has [ qw(
    total_message_count
) ] => (is => 'ro', isa => Maybe[Int], lazy => 1, builder => 1);

# TODO
#has created_by => (is => 'ro', isa => Maybe[InstanceOf[view 'User']], lazy => 1, builder => 1);
#has team       => (is => 'ro', isa => Maybe[InstanceOf[view 'Team']], lazy => 1, builder => 1);

################################################################################

sub _build_created_at {
    my $self = shift;

    return $self->_from_epoch($self->raw_data->{create_at});
}

sub _build_delete_at {
    my $self = shift;

    return $self->_from_epoch($self->raw_data->{delete_at});
}

sub _build_extra_updated_at {
    my $self = shift;

    return $self->_from_epoch($self->raw_data->{extra_updated_at});
}

sub _build_updated_at {
    my $self = shift;

    return $self->_from_epoch($self->raw_data->{updated_at});
}

sub _build_creator_id {
    my $self = shift;

    return $self->raw_data->{creator_id};
}

sub _build_display_name {
    my $self = shift;

    return $self->raw_data->{display_name};
}

sub _build_header {
    my $self = shift;

    return $self->raw_data->{header};
}

sub _build_id {
    my $self = shift;

    return $self->raw_data->{id};
}

sub _build_name {
    my $self = shift;

    return $self->raw_data->{name};
}

sub _build_purpose {
    my $self = shift;

    return $self->raw_data->{purpose};
}

sub _build_team_id {
    my $self = shift;

    return $self->raw_data->{team_id};
}

sub _build_type {
    my $self = shift;

    return $self->raw_data->{type} eq 'O' ? 'Public' : 'Private';
}

sub _build_total_message_count {
    my $self = shift;

    return $self->raw_data->{total_message_count};
}

# TODO
#sub _build_created_by {
#    my $self = shift;
#
#    return unless $self->creator_id;
#    my $ret = $self->api->users->get_by_id($self->creator_id);
#
#    p $self->base_url;
#    p $self->auth_token;
#    p $ret;
#
#    return undef;
#}

################################################################################

1;
__END__

=head1 NAME

WebService::Mattermost::API::View::Channel

=head1 DESCRIPTION

Details a Mattermost channel object.

=head2 ATTRIBUTES

=over 4

=item C<created_at>

A DateTime object for when the channel was created.

=item C<delete_at>

A DateTime object for when the channel should be deleted.

=item C<extra_updated_at>

A DateTime object for when the channel was updated (extra).

=item C<last_post_at>

A DateTime object for when the channel was last posted to.

=item C<updated_at>

A DateTime object for when the channel was last updated.

=item C<creator_id>

The ID of the user who created the channel.

=item C<display_name>

The channel's display name.

=item C<header>

The channel's topic

=item C<id>

The channel's ID.

=item C<name>

The channel's real name.

=item C<purpose>

A description of what the channel is for.

=item C<team_id>

The ID of the team the channel belongs to.

=item C<type>

The channel's access type (either "Public" or "Private", translated from "O" or
"P" respectively).

=item C<total_message_count>

The number of messages made in the channel.

=back

=head1 SEE ALSO

=over 4

=item L<Channel documentation|https://api.mattermost.com/#tag/channels>

=back

=head1 AUTHOR

Mike Jones L<email:mike@netsplit.org.uk>

