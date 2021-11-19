#!/usr/bin/env perl

use Test::Exception;
use Test::Spec;

use WebService::Mattermost;
use WebService::Mattermost::V4::API::Resource::Users;
use WebService::Mattermost::V4::API::Response;

use lib 't';

require 'test_helper.pl';

describe 'WebService::Mattermost' => sub {
    share my %vars;

    before each => sub {
        $vars{base_url}  = BASE_URL();
        $vars{init_args} = client_arguments();

        delete $vars{app};
    };

    describe 'with an auth_token' => sub {
        before each => sub {
            $vars{app} = WebService::Mattermost->new({
                %{$vars{init_args}},

                auth_token => 'helloworld',
            });
        };

        it 'does not attempt to log into Mattermost' => sub {
            WebService::Mattermost::V4::API::Resource::Users->expects('login')->never;

            is 'helloworld', $vars{app}->auth_token;
        };

        it 'sets the token on the API resource classes' => sub {
            test_auth_token_was_set_on_resources($vars{app}, 'helloworld');
        };

        it 'sets up an API client with the token' => sub {
            test_api_client($vars{app}, 'helloworld');
        };
    };

    describe 'with missing password' => sub {
        it 'dies with a missing credential error' => sub {
            test_throws_credential_error({
                authenticate => 1,
                base_url     => $vars{base_url},
                password     => '',
                username     => 'foo',
            });
        };
    };

    describe 'with missing username' => sub {
        it 'dies with a missing credential error' => sub {
            test_throws_credential_error({
                authenticate => 1,
                base_url     => $vars{base_url},
                password     => 'foo',
                username     => '',
            });
        };
    };

    describe 'without intending to authenticate' => sub {
        it 'never attempts to authenticate' => sub {
            WebService::Mattermost::V4::API::Resource::Users->expects('login')->never;

            WebService::Mattermost->new({
                authenticate => 0,
                base_url     => $vars{base_url},
                username     => 'foo',
                password     => 'bar',
            });
        };
    };

    describe 'without an auth_token' => sub {
        describe 'login success' => sub {
            before each => sub {
                user_resource_expects_login(response());

                $vars{app} = WebService::Mattermost->new($vars{init_args});
            };

            it 'sets the auth token' => sub {
                is 'whatever', $vars{app}->auth_token;
            };

            it 'sets the token on the API resource classes' => sub {
                test_auth_token_was_set_on_resources($vars{app}, 'whatever');
            };

            it 'sets up an API client with the token' => sub {
                test_api_client($vars{app}, 'whatever');
            };
        };

        describe 'login failure' => sub {
            it 'dies with an "unauthorized" error' => sub {
                user_resource_expects_login(response({
                    is_success => 0,
                    message    => 'Unauthorized',
                }));

                dies_ok { WebService::Mattermost->new($vars{init_args}) } 'Died';

                like $@, qr{^Unauthorized at};
            };
        };
    };
};

runtests unless caller;

sub test_throws_credential_error {
    my $args = shift;

    dies_ok { WebService::Mattermost->new($args) } 'Died';

    like $@, qr{^"username" and "password" are required attributes for authentication};

    return 1;
}

sub test_auth_token_was_set_on_resources {
    my $object = shift;
    my $token  = shift;

    my $was_set = 1;

    foreach my $resource (@{$object->api->resources}) {
        $was_set = 0 unless $resource->auth_token eq $token;
    }

    ok $was_set;

    return 1;
}

sub test_api_client {
    my $object = shift;
    my $token  = shift;

    ok $object->api->isa('WebService::Mattermost::V4::API');

    is $token, $object->api->auth_token;

    my $did_build = 1;

    foreach my $name ($object->api->meta->get_attribute_list) {
        my $attr = $object->api->meta->get_attribute($name);

        if ($attr->has_builder) {
            $did_build = 0 unless $object->api->can($name);
        }
    }

    ok $did_build, 'Built API resource classes';

    return 1;
}
