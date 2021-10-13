#!/usr/bin/env perl -T

use Test::Spec;

require 'test_helper.pl';

describe 'WebService::Mattermost::V4::API::Resource::Analytics' => sub {
    describe '#get' => sub {
        it 'sends a GET request to /analytics/old' => sub {
            my $app  = authorised_webservice_mattermost();
            my $args = {
                name    => 'standard',
                team_id => 'team-1234',
            };

            expects_api_call($app, {
                method     => 'get',
                resource   => 'analytics',
                url        => '/analytics/old',
                parameters => $args,
            });

            ok $app->api->analytics->get($args);
        };
    };
};

runtests unless caller;