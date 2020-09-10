package WebService::Mattermost::TestHelper;

# ABSTRACT: Helper functions for the library's test suite.

use strict;
use warnings;

use Mojo::Message::Response;
use Mojo::Transaction::HTTP;
use Mojo::URL;
use Test::Most;

require Exporter;

use WebService::Mattermost;
use WebService::Mattermost::V4::API::Resource::Users;
use WebService::Mattermost::V4::API::Response;

use constant {
    AUTH_TOKEN => 'whatever',
    BASE_URL   => 'https://my-mattermost-server.com/api/v4',
    USERNAME   => 'myusername',
    PASSWORD   => 'mypassword',
};

our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(
    AUTH_TOKEN
    BASE_URL
    PASSWORD
    USERNAME

    client_arguments
    headers
    mojo_response
    mojo_tx
    resource_url
    response
    webservice_mattermost
    user_resource_expects_login

    expects_api_call
    test_id_error
    test_single_response_of_type
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

sub headers {
    my $extra = shift || {};

    return {
        'Keep-Alive'    => 1,
        'Authorization' => 'Bearer '.AUTH_TOKEN,

        %{$extra},
    };
}

sub mojo_response {
    my $args = shift || {};

    return Mojo::Message::Response->new(%{$args});
}

sub mojo_tx {
    return Mojo::Transaction::HTTP->new(res => mojo_response({
        code    => 200,
        message => 'OK',
    }));
}

sub webservice_mattermost {
    my $extra = shift || {};

    return WebService::Mattermost->new({
        base_url => BASE_URL,
        username => USERNAME,
        password => PASSWORD,

        %{$extra},
    });
}

sub resource_url {
    my $endpoint = shift;

    return Mojo::URL->new(sprintf('%s%s', BASE_URL, $endpoint));
}

sub response {
    my $args = shift || {};

    my $headers = Mojo::Headers->new();

    $headers->add(token => AUTH_TOKEN);

    return WebService::Mattermost::V4::API::Response->new({
        content    => { id => 'asd1234' },
        base_url   => BASE_URL,
        auth_token => AUTH_TOKEN,
        code       => 200,
        headers    => $headers,
        prev       => mojo_response(),

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

sub expects_api_call {
    my $app  = shift;
    my $args = shift;
    
    my $resource = $args->{resource};

    return $app->api->$resource->ua->expects($args->{method})->with_deep(
        resource_url($args->{url}) => headers(),
        form                       => $args->{parameters} || {},
    )->returns(mojo_tx())->once;
}

sub test_id_error {
    my $input = shift;

    is_deeply {
        error   => 1,
        message => 'Invalid or missing ID parameter. No API query was made.',
    }, $input;

    return 1;
}

sub test_single_response_of_type {
    my $response = shift;
    my $type     = shift;

    is 1, scalar @{$response->items};

    is $type, ref $response->item;

    return 1;
}

################################################################################

1;
__END__

=head1 DESCRIPTION

Exports subroutines used by the library's test suite.

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

=item * C<client_arguments()>

Basic arguments required for L<WebService::Mattermost>.

=item * C<response()>

A dummy L<Mojo::Message::Response>.

=item * C<webservice_mattermost()>

Creates a L<WebService::Mattermost> object with some defaults.

=item * C<user_resource_expects_login()>

Stubs the user resource's "login" method with a successful response. This can be
used to fake a successful login call.

=back
