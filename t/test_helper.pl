#!/usr/bin/env perl

use Test::Spec;

use WebService::Mattermost;

use constant {
    AUTH_TOKEN => 'whatever',
    BASE_URL   => 'https://my-mattermost-server.com/api/v4',
    USERNAME   => 'myusername',
    PASSWORD   => 'mypassword',
};

use lib 't';

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

    # An "assembled_form_type" is an override configured in some API resources,
    # where POST/PUT might not necessarily mean a JSON endpoint (e.g. file
    # uploads).
    if ($args->{assembled_form_type}) {
        $form_type = $args->{assembled_form_type};
    }

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

sub expects_api_call_of_type {
    my $type = shift;
    my $vars = shift;

    my $app = authorised_webservice_mattermost();

    # "assembled_parameters" is used when a class method takes an abstract set
    # of parameters (e.g. a single string) and assembles them into some sort of
    # API form data. "class_method_closure_args" are the plain arguments passed
    # to the class method, and are used in all other cases.
    my $parameters = $vars->{assembled_parameters} || $vars->{class_method_closure_args};

    expects_api_call($app, {
        assembled_form_type  => $vars->{assembled_form_type},
        assembled_parameters => $vars->{assembled_parameters},
        method               => $type,
        parameters           => $parameters,
        resource             => $vars->{resource},
        url                  => $vars->{url},
    });

    ok my $res = $vars->{class_method_closure}->($app, $vars->{class_method_closure_args}),
        sprintf 'sends a %s request to %s', uc $type, $vars->{url};
    
    if ($vars->{object}) {
        my $object = sprintf 'WebService::Mattermost::V4::API::Object::%s', $vars->{object};

        is ref $res->item, $object, "a ${object} was returned";
    }

    return 1;
}

shared_examples_for 'a GET API endpoint' => sub {
    share my %vars;

    it 'sends a GET request' => sub {
        return expects_api_call_of_type('get', $vars{get_request});
    };
};

shared_examples_for 'a POST API endpoint' => sub {
    share my %vars;

    it 'sends a POST request' => sub {
        return expects_api_call_of_type('post', $vars{post_request});
    };
};

1;