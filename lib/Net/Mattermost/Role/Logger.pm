package Net::Mattermost::Role::Logger;

use Moo::Role;
use Types::Standard 'InstanceOf';

use Net::Mattermost::Util::Logger;
use Net::Mattermost::Helper::Alias 'util';

################################################################################

has logger => (is => 'ro', isa => InstanceOf['Log::Log4perl::Logger'], lazy => 1, builder => 1);

################################################################################

sub _build_logger {
    return util('Logger')->new->logger;
}

################################################################################

1;
__END__

=head1 NAME

Net::Mattermost::Role::Logger

=head1 DESCRIPTION

Bundle a C<Log::Log4perl::Logger> object into a Moo class.

=head2 SYNOPSIS

    use Moo;

    with 'Net::Mattermost::Role::Logger';

    sub something {
        my $self = shift;

        $self->logger->warn('Foo');
    }

=head2 ATTRIBUTES

=over 4

=item C<logger>

A C<Log::Log4perl::Logger> object instantiated with easy_init and a level of
C<$DEBUG>.

=back

=head1 SEE ALSO

=over 4

=item C<Net::Mattermost::Util::Logger>

=item C<Log::Log4perl>

=back

=head1 AUTHOR

Mike Jones L<email:mike@netsplit.org.uk>

