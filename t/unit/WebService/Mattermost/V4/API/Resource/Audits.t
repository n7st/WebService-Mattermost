#!/usr/bin/env perl -T

use Test::Spec;

require 'test_helper.pl';

describe 'WebService::Mattermost::V4::API::Resource::Audits' => sub {
    share my %vars;

    describe '#get' => sub {
        before all => sub {
            $vars{get_request} = {
                args     => { page => 1, per_page => 10 },
                method   => sub { return shift->api->audits->get(shift) },
                resource => 'audits',
                url      => '/audits',
            };
        };

        it_should_behave_like 'a GET API endpoint';
    };
};

runtests unless caller;