package WebService::Mattermost::API::v4::Object::Role::BelongingToUser;

use Moo::Role;
use Types::Standard qw(InstanceOf Maybe Str);

use WebService::Mattermost::Helper::Alias 'view';

requires 'raw_data';

################################################################################

has creator_id => (is => 'ro', isa => Maybe[Str],                     lazy => 1, builder => 1);
#has created_by => (is => 'ro', isa => Maybe[InstanceOf[view 'User']], lazy => 1, builder => 1);

################################################################################

sub _build_creator_id {
    my $self = shift;

    return $self->raw_data->{creator_id} || $self->raw_data->{user_id};
}

sub _build_created_by {
    # TODO
}

################################################################################

1;
__END__

=head1 NAME

WebService::Mattermost::API::v4::Object::Role::BelongingToUser

=head1 DESCRIPTION

Link a view object to its creator.

=head2 ATTRIBUTES

=over 4

=item C<creator_id>

The creator's string ID.

=item C<created_by>

In progress - linked C<WebService::Mattermost::API::v4::Object::User> object.

=back

=head1 AUTHOR

Mike Jones L<email:mike@netsplit.org.uk>

