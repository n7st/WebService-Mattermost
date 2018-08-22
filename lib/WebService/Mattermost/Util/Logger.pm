package WebService::Mattermost::Util::Logger;

use Moo;
use Mojo::Util 'monkey_patch';
use Mojo::Log;
use Types::Standard 'InstanceOf';

################################################################################

has logger => (is => 'ro', isa => InstanceOf['Mojo::Log'], lazy => 1, builder => 1);

has logger_store => (is => 'rw', isa => InstanceOf['Mojo::Log']);

################################################################################

monkey_patch 'Mojo::Log',
    debugf => sub { shift->debug(sprintf(shift, @_)) },
    infof  => sub { shift->info(sprintf(shift, @_))  },
    fatalf => sub { shift->fatal(sprintf(shift, @_)) },
    warnf  => sub { shift->warn(sprintf(shift, @_))  };

################################################################################

sub _build_logger {
    my $self = shift;

    unless ($self->logger_store) {
        $self->logger_store(Mojo::Log->new());
    }

    return $self->logger_store;
}

################################################################################

1;
__END__

