package WebService::Mattermost::API::v4::Resource::Brand;

use Moo;

extends 'WebService::Mattermost::API::v4::Resource';

################################################################################

sub current {
    my $self = shift;

    return $self->_get({ endpoint => 'image' });
}

sub upload {
    my $self     = shift;
    my $filename = shift;

    return $self->_post({
        endpoint   => 'image',
        parameters => {
            image => { file => $filename },
        },
    });
}

################################################################################

1;
__END__

=head1 NAME

WebService::Mattermost::API::v4::Resource::Brand

=head1 DESCRIPTION

=head2 USAGE

    use WebService::Mattermost;

    my $mm = WebService::Mattermost->new({
        authenticate => 1,
        username     => 'email@address.com',
        password     => 'passwordhere',
        base_url     => 'https://my.mattermost.server.com/api/v4/',
    });

    my $brand = $mm->api->brand;

=head2 METHODS

=over 4

=item C<current()>

Get the current brand image for your Mattermost server.

    my $response = $brand->current;

=item C<upload()>

Set a new brand image for your Mattermost server.

    my $response = $brand->upload('/path/to/image.jpg');

=back

=head1 SEE ALSO

=over 4

=item L<https://api.mattermost.com/#tag/brand>

Official "brand" API documentation.

=back

=head1 AUTHOR

Mike Jones L<email:mike@netsplit.org.uk>

