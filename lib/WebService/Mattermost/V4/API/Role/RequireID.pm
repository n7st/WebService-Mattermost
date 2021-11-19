package WebService::Mattermost::V4::API::Role::RequireID;

# ABSTRACT: ID validation.

use Moo::Role;
use Types::Standard 'RegexpRef';

requires 'error_return';

################################################################################

has id_validation_regexp => (is => 'ro', isa => RegexpRef, default => sub { qr{(?i)^[a-z0-9\-]+$} });

################################################################################

sub validate_id {
    my $self = shift;
    my $next = shift;
    my $id   = shift || $self->id;

    if ($self->validate_id_no_next($id)) {
        return $self->$next($id, @_);
    }

    return $self->error_return('Invalid or missing ID parameter');
}

sub validate_id_no_next {
    my $self = shift;
    my $id   = shift || $self->id;

    return ($id && $id =~ $self->id_validation_regexp) ? 1 : 0;
}

################################################################################

1;
__END__

=head1 DESCRIPTION

Validate that the first parameter passed to a subroutine is a valid UUID for
Mattermost.

=head2 METHODS

=over 4

=item C<validate_id()>

Validate the ID and run the next subroutine.

=item C<validate_id_no_next()>

Validate the ID but do not run the next subroutine.

=back

=head2 ATTRIBUTES

=over 4

=item C<id_validation_regexp>

Basic UUID matching regular expression.

=back
