package WebService::Mattermost::TestHelper;

use strict;
use warnings;

use Test::Most;

require Exporter;

use WebService::Mattermost;
use WebService::Mattermost::V4::API::Resource::Users;
use WebService::Mattermost::V4::API::Response;

use constant {
    BASE_URL => 'https://my-mattermost-server.com/api/v4',
    USERNAME => 'myusername',
    PASSWORD => 'mypassword',
};

our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(
    BASE_URL
    PASSWORD
    USERNAME

    client_arguments
    response
    webservice_mattermost
    user_resource_expects_login
);

################################################################################

sub client_arguments {
    my $extra = shift || {};

    return {
        authenticate => 1,
        base_url     => BASE_URL,
        password     => PASSWORD,
        username     => USERNAME,

        %{$extra}
    };
}

sub webservice_mattermost {
    return WebService::Mattermost->new({
        base_url => BASE_URL,
        username => USERNAME,
        password => PASSWORD,
    });
}

sub response {
    my $args = shift || {};

    my $headers = Mojo::Headers->new();

    $headers->add(token => 'whatever');

    return WebService::Mattermost::V4::API::Response->new({
        content    => { id => 'asd1234' },
        base_url   => BASE_URL,
        auth_token => 'whatever',
        code       => 200,
        headers    => $headers,
        prev       => Mojo::Message::Response->new(),

        %{$args},
    });
}

sub user_resource_expects_login {
    my $responds_with = shift;

    my $args = client_arguments();

    WebService::Mattermost::V4::API::Resource::Users
        ->stubs('login')
        ->with($args->{username}, $args->{password})
        ->once
        ->returns($responds_with);
}

################################################################################

1;
__END__

=head1 NAME

WebService::Mattermost::TestHelper - Helper functions for the test suite.

=head1 DESCRIPTION

=head2 SYNPOSIS

Test files should import the helper as follows:

    # Exported functions are listed in METHODS
    use WebService::Mattermost::TestHelper qw(
        webservice_mattermost
        ...
    );

    my $mattermost = webservice_mattermost();

=head2 METHODS

=over 4

=item * C<webservice_mattermost()>

Creates a L<WebService::Mattermost> object with some defaults.

=back

=head1 AUTHOR

L<Mike Jones|email:mike@netsplit.org.uk>
