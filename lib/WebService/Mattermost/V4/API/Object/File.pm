package WebService::Mattermost::V4::API::Object::File;

use Moo;
use Types::Standard qw(Bool Int Maybe Str);

extends 'WebService::Mattermost::V4::API::Object';
with    qw(
    WebService::Mattermost::V4::API::Object::Role::BelongingToPost
    WebService::Mattermost::V4::API::Object::Role::BelongingToUser
    WebService::Mattermost::V4::API::Object::Role::ID
    WebService::Mattermost::V4::API::Object::Role::Name
    WebService::Mattermost::V4::API::Object::Role::Timestamps
);

################################################################################

has [ qw(extension mime_type) ] => (is => 'ro', isa => Maybe[Str],  lazy => 1, builder => 1);
has [ qw(size width height)   ] => (is => 'ro', isa => Maybe[Int],  lazy => 1, builder => 1);
has has_preview_image           => (is => 'ro', isa => Maybe[Bool], lazy => 1, builder => 1);

################################################################################

sub _build_extension         { shift->raw_data->{extension}                 }
sub _build_mime_type         { shift->raw_data->{mime_type}                 }
sub _build_size              { shift->raw_data->{size}                      }
sub _build_width             { shift->raw_data->{width}                     }
sub _build_height            { shift->raw_data->{height}                    }
sub _build_has_preview_image { shift->raw_data->{has_preview_image} ? 1 : 0 }

################################################################################

1;
__END__

=head1 NAME

WebService::Mattermost::V4::API::Object::File

=head1 DESCRIPTION

Details a Mattermost File object.

=head2 ATTRIBUTES

=over 4

=item C<extension>

=item C<has_preview_image>

=item C<height>

=item C<mime_type>

=item C<size>

=item C<width>

=back

=head1 SEE ALSO

=over 4

=item C<WebService::Mattermost::V4::API::Object::Role::BelongingToPost>

=item C<WebService::Mattermost::V4::API::Object::Role::BelongingToUser>

=item C<WebService::Mattermost::V4::API::Object::Role::ID>

=item C<WebService::Mattermost::V4::API::Object::Role::Name>

=item C<WebService::Mattermost::V4::API::Object::Role::Timestamps>

=back

=head1 AUTHOR

Mike Jones L<email:mike@netsplit.org.uk>

