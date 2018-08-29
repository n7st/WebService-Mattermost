package WebService::Mattermost::API::v4::Object::Channel;

use Moo;
use Types::Standard qw(HashRef InstanceOf Int Maybe Str);

extends 'WebService::Mattermost::API::v4::Object';
with    qw(
    WebService::Mattermost::API::v4::Object::Role::Timestamps
    WebService::Mattermost::API::v4::Object::Role::BelongingToUser
    WebService::Mattermost::API::v4::Object::Role::BelongingToTeam
    WebService::Mattermost::API::v4::Object::Role::ID
    WebService::Mattermost::API::v4::Object::Role::Name
);

################################################################################

has [ qw(
    extra_updated_at
    last_post_at
) ] => (is => 'ro', isa => Maybe[InstanceOf['DateTime']], lazy => 1, builder => 1);

has [ qw(
    display_name
    header
    purpose
    type
) ] => (is => 'ro', isa => Maybe[Str], lazy => 1, builder => 1);

has [ qw(
    total_message_count
) ] => (is => 'ro', isa => Maybe[Int], lazy => 1, builder => 1);

################################################################################

sub _build_extra_updated_at {
    my $self = shift;

    return $self->_from_epoch($self->raw_data->{extra_updated_at});
}

sub _build_display_name {
    my $self = shift;

    return $self->raw_data->{display_name};
}

sub _build_header {
    my $self = shift;

    return $self->raw_data->{header};
}

sub _build_purpose {
    my $self = shift;

    return $self->raw_data->{purpose};
}

sub _build_type {
    my $self = shift;

    return $self->raw_data->{type} eq 'O' ? 'Public' : 'Private';
}

sub _build_total_message_count {
    my $self = shift;

    return $self->raw_data->{total_message_count};
}

################################################################################

1;
__END__

=head1 NAME

WebService::Mattermost::API::v4::Object::Channel

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

