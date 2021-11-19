#!/usr/bin/env perl

use Test::Spec;

use WebService::Mattermost::V4::Client;

use lib 't';

require 'test_helper.pl';

describe 'WebService::Mattermost::V4::Client' => sub {
    share my %vars;

    before each => sub {
        $vars{init_args} = client_arguments();

        user_resource_expects_login(response());

        $vars{app} = WebService::Mattermost::V4::Client->new($vars{init_args});
    };

    describe 'roles' => sub {
        it 'should include the logger role' => sub {
            ok $vars{app}->does('WebService::Mattermost::Role::Logger');
        };
    };

    describe '#websocket_url' => sub {
        context 'with trailing slash' => sub {
            it 'should switch the HTTP API URL for a websocket one' => sub {
                is 'wss://my-mattermost-server.com/api/v4/websocket', $vars{app}->websocket_url;
            };
        };
    };

    describe '#ua' => sub {
        it 'should be an empty Mojo::UserAgent, not the API UA' => sub {
            is 'Mojo::UserAgent', ref $vars{app}->ua;
            isnt 'WebService::Mattermost::Util::UserAgent', ref $vars{app}->{ua};
        };
    };

    describe '#start' => sub {
        it 'should open a WebSocket connection' => sub {
            Mojo::UserAgent
                ->expects('websocket')
                ->once;

            $vars{app}->start;

            ok 1;
        };

        context 'debugging enabled' => sub {
            it 'should log connection information' => sub {
                SKIP: {
                    skip 'Test not yet complete', 1;
                    ok 1;
                };
            };
        };

        context 'debugging disabled' => sub {
            it 'should not log connection information' => sub {
                SKIP: {
                    skip 'Test not yet complete', 1;
                    ok 1;
                };
            };
        };

        it 'should set connection headers on the useragent' => sub {
            SKIP: {
                skip 'Test not yet complete', 1;
                ok 1;
            };
        };

        it 'should create a websocket loop' => sub {
            SKIP: {
                skip 'Test not yet complete', 1;
                ok 1;
            };
        };

        it 'should start the ioloop' => sub {
            Mojo::IOLoop->expects('start')->once;
            Mojo::IOLoop->expects('is_running')->returns(0)->at_least_once;

            $vars{app}->start;

            ok 1;
        };
    };

    describe '#message_has_content' => sub {
        context 'with a real message' => sub {
            it 'return the message' => sub {
                is $vars{app}->message_has_content({
                    post_data => { message => 'Yay!' },
                }), 'Yay!';
            };
        };

        context 'with no post_content' => sub {
            it 'should return undef' => sub {
                is $vars{app}->message_has_content({}), undef;
            };
        };

        context 'with no message' => sub {
            it 'should return undef' => sub {
                is $vars{app}->message_has_content({ post_content => {} }), undef;
            };
        };
    };
};

runtests unless caller;

