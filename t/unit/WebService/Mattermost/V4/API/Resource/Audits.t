#!/usr/bin/env perl -T

use Test::Spec;

require 'test_helper.pl';

describe 'WebService::Mattermost::V4::API::Resource::Audits' => sub {
    share my %vars;

    describe '#get' => sub {
        before all => sub {
            $vars{get_request} = {
                class_method_closure      => sub { return shift->api->audits->get(shift) },
                class_method_closure_args => { page => 1, per_page => 10 },
                object                    => 'Audit',
                resource                  => 'audits',
                url                       => '/audits',
            };
        };

        it_should_behave_like 'a "single" GET API endpoint';
    };
};

runtests unless caller;