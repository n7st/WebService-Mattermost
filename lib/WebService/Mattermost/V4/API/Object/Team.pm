package WebService::Mattermost::V4::API::Object::Team;

# ABSTRACT: A team item.

use Moo;
use Types::Standard qw(Bool InstanceOf Str);

use WebService::Mattermost::Helper::Alias 'v4';

extends 'WebService::Mattermost::V4::API::Object';
with    qw(
    WebService::Mattermost::V4::API::Object::Role::APIMethods
    WebService::Mattermost::V4::API::Object::Role::Name
    WebService::Mattermost::V4::API::Object::Role::Description
    WebService::Mattermost::V4::API::Object::Role::ID
    WebService::Mattermost::V4::API::Object::Role::Timestamps
);

################################################################################

has channels       => (is => 'lazy', isa => InstanceOf[v4 'Team::Channels']);
has company_name   => (is => 'lazy', isa => Str);
has display_name   => (is => 'lazy', isa => Str);
has email          => (is => 'lazy', isa => Str);
has invite_id      => (is => 'lazy', isa => Str);
has is_invite_only => (is => 'lazy', isa => Bool);
has open_invite    => (is => 'lazy', isa => Bool);

################################################################################

sub BUILD {
    my $self = shift;

    $self->api_resource_name('team');
    $self->set_available_api_methods([ qw(
        add_member
        add_members
        channels.public
        delete
        get_icon
        invite_by_emails
        members
        members_by_ids
        patch
        remove_icon
        search_posts
        set_icon
        set_scheme
        stats
        update
    ) ]);

    return 1;
}

################################################################################

sub _build_channels {
    my $self = shift;

    my $team_channels = $self->new_related_resource('teams', 'Team::Channels');

    $team_channels->id($self->id);

    return $team_channels;
}

sub _build_company_name   { shift->raw_data->{company_name}        }
sub _build_display_name   { shift->raw_data->{display_name}        }
sub _build_email          { shift->raw_data->{email}               }
sub _build_invite_id      { shift->raw_data->{invite_id}           }
sub _build_is_invite_only { shift->raw_data->{type} eq 'I' ? 1 : 0 }
sub _build_open_invite    { shift->raw_data->{open_invite} ? 1 : 0 }

################################################################################

1;
__END__

=head1 DESCRIPTION

Object version of a Mattermost team.

=head2 METHODS

See matching methods in L<WebService::Mattermost::V4::API::Resource::Team>
for full documentation.

ID parameters are not required:

    my $response = $mattermost->api->team->get('ID-HERE')->item->delete();

Is the same as:

    my $response = $mattermost->api->team->delete('ID-HERE');

=over 4

=item C<add_member()>

=item C<add_members()>

=item C<delete()>

=item C<get_icon()>

=item C<invite_by_emails()>

=item C<members()>

=item C<members_by_ids()>

=item C<patch()>

=item C<remove_icon()>

=item C<search_posts()>

=item C<set_icon()>

=item C<set_scheme()>

=item C<stats()>

=item C<update()>

=back

=head2 ATTRIBUTES

=over 4

=item C<id>

The team's ID.

=item C<name>

The team's name.

=item C<display_name>

=item C<email>

Contact address for the team.

=item C<invite_id>

=item C<is_invite_only>

Boolean.

=item C<open_invite>

Boolean.

=back

=head1 SEE ALSO

=over 4

=item L<WebService::Mattermost::V4::API::Resource::Team>

=item L<WebService::Mattermost::V4::API::Resource::Teams>

=item L<WebService::Mattermost::V4::API::Object::Role::Name>

=item L<WebService::Mattermost::V4::API::Object::Role::Description>

=item L<WebService::Mattermost::V4::API::Object::Role::ID>

=item L<WebService::Mattermost::V4::API::Object::Role::Timestamps>

=back
