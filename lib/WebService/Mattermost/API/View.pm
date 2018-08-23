package WebService::Mattermost::API::View;

use DateTime;
use Moo;

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

