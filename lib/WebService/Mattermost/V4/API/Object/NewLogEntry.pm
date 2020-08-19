package WebService::Mattermost::V4::API::Object::NewLogEntry;

# ABSTRACT: A new log entry item.

use Moo;
use Types::Standard qw(Maybe InstanceOf Int Str);

extends 'WebService::Mattermost::V4::API::Object';
with    'WebService::Mattermost::V4::API::Object::Role::Message';

################################################################################

has level => (is => 'ro', isa => Maybe[Str], lazy => 1, builder => 1);

################################################################################

sub _build_level  { shift->raw_data->{level}  }

################################################################################

1;
__END__

=head1 DESCRIPTION

Details a Mattermost NewLogEntry object.

=head1 SEE ALSO

=over 4

=item L<WebService::Mattermost::V4::API::Object::Role::Message>

=back
