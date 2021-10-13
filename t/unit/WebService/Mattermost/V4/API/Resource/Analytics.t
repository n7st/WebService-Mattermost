#!/usr/bin/env perl -T

use Test::Spec;

require 'test_helper.pl';

describe 'WebService::Mattermost::V4::API::Resource::Analytics' => sub {
    share my %vars;

    describe '#get' => sub {
        before all => sub {
            $vars{get_request} = {
                args                 => { name => 'standard', team_id => 'team-1234' },
                class_method_closure => sub { return shift->api->analytics->get(shift) },
                url                  => '/analytics/old',
                resource             => 'analytics',
                object               => 'Analytics::Old',
            };
        };

        it_should_behave_like 'a "single" GET API endpoint';
    };
};

runtests unless caller;