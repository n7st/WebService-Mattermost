package Net::Mattermost::API::Response;

use DDP;
use Mojo::JSON 'decode_json';
use Moo;
use Types::Standard qw(Any Bool HashRef InstanceOf Int Str);

################################################################################

has code        => (is => 'ro', isa => Int,                         required => 1);
has headers     => (is => 'ro', isa => InstanceOf['Mojo::Headers'], required => 1);
has message     => (is => 'ro', isa => Str,                         required => 0);
has raw_content => (is => 'ro', isa => Str,                         required => 0);

has is_error   => (is => 'ro', isa => Bool, default => 0);
has is_success => (is => 'ro', isa => Bool, default => 1);

has content => (is => 'rw', isa => Any, default => sub { {} });

################################################################################

sub BUILD {
    my $self = shift;

    if ($self->raw_content) {
        $self->content(decode_json($self->raw_content));
    }

    return 1;
}

################################################################################

1;

