#!/usr/bin/env perl -T

use Test::Spec;

use WebService::Mattermost::TestHelper qw(
    AUTH_TOKEN

    expects_api_call
    webservice_mattermost
);

describe 'WebService::Mattermost::V4::API::Resource::User' => sub {
    share my %vars;

    describe '#update_active_status' => sub {
        before each => sub {
            $vars{app} = webservice_mattermost({
                authenticate => 0,
                auth_token   => AUTH_TOKEN,
            });
        };

        it 'should send a PUT request to /user/{id}/active with the new status' => sub {
            my $user_id = 'user-1234';
            my $params  = { active => 1 };

            expects_api_call($vars{app}, {
                resource   => 'user',
                method     => 'put',
                url        => "/users/${user_id}/active",
                parameters => $params,
            });

            ok $vars{app}->api->user->update_active_status($user_id, $params);
        };
    };
};

runtests unless caller;

