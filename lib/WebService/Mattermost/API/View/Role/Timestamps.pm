package WebService::Mattermost::API::View::Role::Timestamps;

use Moo::Role;
use Types::Standard qw(InstanceOf Int);

requires qw(_from_epoch raw_data);

################################################################################

has [ qw(create_at delete_at update_at) ]    => (is => 'ro', isa => Int,                    lazy => 1, builder => 1);
has [ qw(created_at deleted_at updated_at) ] => (is => 'ro', isa => InstanceOf['DateTime'], lazy => 1, builder => 1);

################################################################################

sub _build_create_at {
    my $self = shift;

    return $self->raw_data->{create_at};
}

sub _build_delete_at {
    my $self = shift;

    return $self->raw_data->{delete_at};
}

sub _build_update_at {
    my $self = shift;

    return $self->raw_data->{update_at};
}

sub _build_created_at {
    my $self = shift;

    return $self->_from_epoch($self->raw_data->{create_at});
}

sub _build_deleted_at {
    my $self = shift;

    return $self->_from_epoch($self->raw_data->{delete_at});
}

sub _build_updated_at {
    my $self = shift;

    return $self->_from_epoch($self->raw_data->{updated_at});
}

################################################################################

1;
__END__

=head1 NAME

WebService::Mattermost::API::View::Role::Timestamps

=head1 DESCRIPTION

Attach common timestamps to a View object.

=head2 ATTRIBUTES

=over 4

=item C<create_at>

UNIX timestamp.

=item C<delete_at>

UNIX timestamp.

=item C<update_at>

UNIX timestamp.

=item C<created_at>

C<DateTime> object.

=item C<deleted_at>

C<DateTime> object.

=item C<updated_at>

C<DateTime> object.

=back

=head1 AUTHOR

Mike Jones L<email:mike@netsplit.org.uk>

