package Net::Mattermost::Util::Logger;

use Log::Log4perl::Level;
use Log::Log4perl ':easy';
use Moo;
use Mojo::Util 'monkey_patch';
use Types::Standard 'InstanceOf';

################################################################################

has logger => (is => 'ro', isa => InstanceOf['Log::Log4perl::Logger'], lazy => 1, builder => 1);

has logger_store => (is => 'rw', isa => InstanceOf['Log::Log4perl::Logger']);

################################################################################

monkey_patch 'Log::Log4perl::Logger',
    debugf  => sub { shift->debug(sprintf(shift, @_))  },
    infof   => sub { shift->info(sprintf(shift, @_))   },
    logdief => sub { shift->logdie(sprintf(shift, @_)) },
    warnf   => sub { shift->warn(sprintf(shift, @_))   };

################################################################################

sub _build_logger {
    my $self = shift;

    unless ($self->logger_store) {
        Log::Log4perl::easy_init($DEBUG);

        $self->logger_store(Log::Log4perl::get_logger());
    }

    return $self->logger_store;
}

################################################################################

1;
__END__

