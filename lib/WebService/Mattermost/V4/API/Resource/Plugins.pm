package WebService::Mattermost::V4::API::Resource::Plugins;

use Moo;

extends 'WebService::Mattermost::V4::API::Resource';
with    'WebService::Mattermost::V4::API::Resource::Role::View::Plugins';

################################################################################

sub upload {
    my $self     = shift;
    my $filename = shift;

    return $self->_single_view_post({
        required   => [ qw(plugin) ],
        parameters => {
            plugin => { file => $filename },
        },
        view       => 'Status',
    });
}

sub all {
    my $self = shift;

    return $self->_get();
}

################################################################################

1;
__END__

=head2 METHODS

=over 4

=item C<upload()>

L<Upload plugin|https://api.mattermost.com/#tag/plugins%2Fpaths%2F~1plugins%2Fpost>

    my $response = $resource->upload('/path/to/plugin.tar.gz');

=back

