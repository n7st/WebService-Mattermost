package WebService::Mattermost::V4::API::Object::Team;

use Moo;
use Types::Standard qw(Bool Str);

extends 'WebService::Mattermost::V4::API::Object';
with    qw(
    WebService::Mattermost::V4::API::Object::Role::Name
    WebService::Mattermost::V4::API::Object::Role::ID
    WebService::Mattermost::V4::API::Object::Role::Timestamps
);

################################################################################

has company_name => (is => 'ro', isa => Str,  lazy => 1, builder => 1);
has description  => (is => 'ro', isa => Str,  lazy => 1, builder => 1);
has display_name => (is => 'ro', isa => Str,  lazy => 1, builder => 1);
has email        => (is => 'ro', isa => Str,  lazy => 1, builder => 1);
has invite_id    => (is => 'ro', isa => Str,  lazy => 1, builder => 1);
has is_private   => (is => 'ro', isa => Bool, lazy => 1, builder => 1);
has open_invite  => (is => 'ro', isa => Bool, lazy => 1, builder => 1);

################################################################################

sub _build_company_name { shift->raw_data->{company_name}        }
sub _build_description  { shift->raw_data->{description}         }
sub _build_display_name { shift->raw_data->{display_name}        }
sub _build_email        { shift->raw_data->{email}               }
sub _build_invite_id    { shift->raw_data->{invite_id}           }
sub _build_is_private   { shift->raw_data->{type} eq 'P' ? 1 : 0 }
sub _build_open_invite  { shift->raw_data->{open_invite} ? 1 : 0 }

################################################################################

1;
__END__

=head1 NAME

WebService::Mattermost::V4::API::Object::Team

=head1 DESCRIPTION

Object version of a Mattermost team.

=head2 ATTRIBUTES

=over 4

=item C<id>

The team's ID.

=item C<name>

The team's name.

=item C<description>

=item C<display_name>

=item C<email>

Contact address for the team.

=item C<invite_id>

=item C<is_private>

Boolean.

=item C<open_invite>

Boolean.

=back

=head1 SEE ALSO

=over 4

=item C<WebService::Mattermost::V4::API::Object::Role::Name>

=item C<WebService::Mattermost::V4::API::Object::Role::ID>

=item C<WebService::Mattermost::V4::API::Object::Role::Timestamps>

=back

=head1 AUTHOR

Mike Jones L<email:mike@netsplit.org.uk>

