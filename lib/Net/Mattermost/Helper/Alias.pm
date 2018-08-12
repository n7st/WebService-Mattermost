package Net::Mattermost::Helper::Alias;

use strict;
use warnings;

use Readonly;

require Exporter;

use vars qw(@ISA @EXPORT_OK);

@ISA       = 'Exporter';
@EXPORT_OK = qw(v4 util);

Readonly::Scalar my $v4_base   => 'Net::Mattermost::API::v4::Resource::';
Readonly::Scalar my $util_base => 'Net::Mattermost::Util::';

################################################################################

sub v4 {
    my $name = shift;

    return sprintf('%s%s', $v4_base, $name);
}

sub util {
    my $name = shift;

    return sprintf('%s%s', $util_base, $name);
}

################################################################################

1;
__END__

=head1 NAME

Net::Mattermost::Helper::Alias

=head1 DESCRIPTION

Static helpers used in the library.

=head2 METHODS

=over 4

=item C<v4()>

Format the name of an endpoint for the version 4 API.

    use Net::Mattermost::Helper::Alias 'v4';

    print v4   'Teams';     # prints Net::Mattermost::API::v4::Resource::Teams
    print util 'UserAgent'; # prints Net::Mattermost::Util::UserAgent

=back

=head1 AUTHOR

Mike Jones L<email:mike@netsplit.org.uk>

