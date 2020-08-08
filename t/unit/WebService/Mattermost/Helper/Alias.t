#!/usr/bin/env perl -T

use Test::Spec;

use WebService::Mattermost::Helper::Alias qw(v4 view util);

describe 'WebService::Mattermost::Helper::Alias' => sub {
    describe 'util' => sub {
        it 'should add the util namespace' => sub {
            is 'WebService::Mattermost::Util::Hello', util('Hello');
        };
    };

    describe 'v4' => sub {
        it 'should add the API v4 namespace' => sub {
            is 'WebService::Mattermost::V4::API::Resource::Hello', v4('Hello');
        };
    };

    describe 'view' => sub {
        it 'should add the API v4 view namespace' => sub {
            is 'WebService::Mattermost::V4::API::Object::Hello', view('Hello');
        };
    };
};

runtests unless caller;
