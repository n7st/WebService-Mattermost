package Net::Mattermost::API::v4::Resource::LDAP;

use Moo;

extends 'Net::Mattermost::API::v4::Resource';

################################################################################

sub sync {
    my $self = shift;

    return $self->_call({
        method   => $self->post,
        endpoint => 'sync',
    });
}

sub test {
    my $self = shift;

    return $self->_call({
        method   => $self->post,
        endpoint => 'test',
    });
}

################################################################################

1;
__END__

=head1 NAME

Net::Mattermost::API::v4::Resource::LDAP

=head1 DESCRIPTION

=head2 USAGE

    use Net::Mattermost;

    my $mm = Net::Mattermost->new({
        authenticate => 1,
        username     => 'email@address.com',
        password     => 'passwordhere',
        base_url     => 'https://my.mattermost.server.com/api/v4/',
    });

    my $ldap = $mm->api->ldap;

=head2 METHODS

=over 4

=item C<sync()>

    $ldap->sync;

=item C<test()>

    $ldap->test;

=back

=head1 SEE ALSO

=over 4

=item L<https://api.mattermost.com/#tag/LDAP>

Official "LDAP" API documentation.

=back

=head1 AUTHOR

Mike Jones L<email:mike@netsplit.org.uk>

