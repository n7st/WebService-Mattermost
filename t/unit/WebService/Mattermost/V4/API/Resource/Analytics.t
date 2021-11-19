#!/usr/bin/env perl -T

use Test::Spec;

use lib 't';

require 'test_helper.pl';

describe 'WebService::Mattermost::V4::API::Resource::Analytics' => sub {
    share my %vars;

    describe '#get' => sub {
        before all => sub {
            $vars{get_request} = {
                class_method_closure      => sub { return shift->api->analytics->get(shift) },
                class_method_closure_args => { name => 'standard', team_id => 'team-1234' },
                object                    => 'Analytics::Old',
                resource                  => 'analytics',
                url                       => '/analytics/old',
            };
        };

        it_should_behave_like 'a GET API endpoint';
    };
};

runtests unless caller;