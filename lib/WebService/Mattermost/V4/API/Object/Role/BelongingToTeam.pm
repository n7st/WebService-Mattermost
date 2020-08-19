package WebService::Mattermost::V4::API::Object::Role::BelongingToTeam;

# ABSTRACT: Mark an object as belonging to a team.

use Moo::Role;
use Types::Standard qw(InstanceOf Maybe Str);

use WebService::Mattermost::Helper::Alias 'view';

################################################################################

has team_id => (is => 'ro', isa => Maybe[Str],                     lazy => 1, builder => 1);
has team    => (is => 'ro', isa => Maybe[InstanceOf[view 'Team']], lazy => 1, builder => 1);

################################################################################

sub _build_team_id {
    my $self = shift;

    return $self->raw_data->{team_id};
}

sub _build_team {
    my $self = shift;

    return unless $self->team_id;
    return $self->api->teams->get_by_id($self->team_id)->item;
}

################################################################################

1;
__END__

=head1 DESCRIPTION

Link a view object to its creator.

=head2 ATTRIBUTES

=over 4

=item C<team_id>

The creator's string ID.

=item C<team>

Linked L<WebService::Mattermost::V4::API::Object::Team> object.

=back
