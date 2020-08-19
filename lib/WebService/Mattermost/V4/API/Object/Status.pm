package WebService::Mattermost::V4::API::Object::Status;

# ABSTRACT: A status object.

use Moo;
use Types::Standard qw(Str Int);

extends 'WebService::Mattermost::V4::API::Object';
with    'WebService::Mattermost::V4::API::Object::Role::Status';

################################################################################

1;
__END__

=head1 DESCRIPTION

Details a Mattermost Status object.

=head1 SEE ALSO

=over 4

=item L<WebService::Mattermost::V4::API::Object::Role::Status>

=back
