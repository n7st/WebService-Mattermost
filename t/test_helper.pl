#!/usr/bin/env perl

use Test::Spec;

use WebService::Mattermost;

use constant {
    AUTH_TOKEN => 'whatever',
    BASE_URL   => 'https://my-mattermost-server.com/api/v4',
    USERNAME   => 'myusername',
    PASSWORD   => 'mypassword',
};

require 'test_helpers/mojo.pl';

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

sub webservice_mattermost {
    my $extra = shift || {};

    return WebService::Mattermost->new({
        base_url => BASE_URL,
        username => USERNAME,
        password => PASSWORD,

        %{$extra},
    });
}

sub authorised_webservice_mattermost {
    return webservice_mattermost({
        auth_token   => AUTH_TOKEN,
        authenticate => 0,
    })
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

    return;
}

sub expects_api_call {
    my $app  = shift;
    my $args = shift;

    my $resource  = $args->{resource};
    my $form_type = $args->{method} eq 'post' || $args->{method} eq 'put' ? 'json' : 'form';

    return $app->api->$resource->ua->expects($args->{method})->with_deep(
        mojo_url($args->{url}) => headers(),
        $form_type             => $args->{parameters} || {},
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

shared_examples_for 'a "single" GET API endpoint' => sub {
    share my %vars;

    it 'sends a GET request' => sub {
        my $app = authorised_webservice_mattermost();

        expects_api_call($app, {
            method     => 'get',
            resource   => $vars{get_request}{resource},
            url        => $vars{get_request}{url},
            parameters => $vars{get_request}{args},
        });

        ok my $res = $vars{get_request}{method}->($app, $vars{get_request}{args}),
            'sends a GET request to ' . $vars{get_request}{url};
        
        if ($vars{get_request}{object}) {
            my $object = sprintf 'WebService::Mattermost::V4::API::Object::%s', $vars{get_request}{object};

            is ref $res->item, $object, "a ${object} was returned";
        }
    };
};

1;