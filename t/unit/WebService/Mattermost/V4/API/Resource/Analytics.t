#!/usr/bin/env perl -T

use Test::Spec;

require 'test_helper.pl';

describe 'WebService::Mattermost::V4::API::Resource::Analytics' => sub {
    share my %vars;

    describe '#get' => sub {
        before all => sub {
            $vars{get_request} = {
                args     => { name => 'standard', team_id => 'team-1234' },
                method   => sub { return shift->api->analytics->get(shift) },
                url      => '/analytics/old',
                resource => 'analytics',
            };
        };

        it_should_behave_like 'a GET API endpoint';
    };
};

runtests unless caller;