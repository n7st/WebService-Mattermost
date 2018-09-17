package WebService::Mattermost::API::View::Role::ID;

use Moo::Role;
use Types::Standard qw(Maybe Str);

requires 'raw_data';

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

=head1 NAME

WebService::Mattermost::API::View::Role::Timestamps

=head1 DESCRIPTION

Attach an ID to a View object.

=head2 ATTRIBUTES

=over 4

=item C<ID>

UUID.

=back

=head1 AUTHOR

Mike Jones L<email:mike@netsplit.org.uk>

