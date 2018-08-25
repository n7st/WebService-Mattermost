package WebService::Mattermost::API::View;

use DateTime;
use Moo;
use Types::Standard qw(HashRef Str);

# TODO
#extends 'WebService::Mattermost';

################################################################################

has raw_data => (is => 'ro', isa => HashRef, required => 1);

################################################################################

sub _from_epoch {
    my $self           = shift;
    my $unix_timestamp = shift;

    return undef unless $unix_timestamp;

    # The timestamp is too precise - trim away the end
    $unix_timestamp =~ s/...$//s;

    return DateTime->from_epoch(epoch => $unix_timestamp);
}

################################################################################

1;

