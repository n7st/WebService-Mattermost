#!/usr/bin/env perl -T

use Test::Spec;

describe 'WebService::Mattermost::V4::API::Resource::Users' => sub {
    share my %vars;

    describe '#update_active_status' => sub {
        before each => sub {};

        it 'should send a PUT request to /users/{id}/active with the new status' => sub {
        };
    };
};

runtests unless caller;

