package WebService::Mattermost::V4::API::Object::Role::ID;

# ABSTRACT: Adds an "id" field to an object.

use Moo::Role;
use Types::Standard qw(Maybe Str);

################################################################################

has id => (is => 'ro', isa => Maybe[Str], lazy => 1, builder => 1);

################################################################################

sub _build_id {
    my $self = shift;

    return $self->raw_data->{id};
}

################################################################################

1;
__END__

=head1 DESCRIPTION

Attach an ID to a v4::Object object.

=head2 ATTRIBUTES

=over 4

=item C<id>

UUID.

=back
