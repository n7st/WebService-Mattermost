#!/usr/bin/env perl

use Test::Spec;

use WebService::Mattermost::V4::Client;
use WebService::Mattermost::TestHelper qw(
    client_arguments
    response
    user_resource_expects_login
);

describe 'WebService::Mattermost::V4::Client' => sub {
    share my %vars;

    before each => sub {
        $vars{init_args} = client_arguments();

        user_resource_expects_login(response());

        $vars{app} = WebService::Mattermost::V4::Client->new($vars{init_args});
    };

    describe 'websocket_url' => sub {
        describe 'with trailing slash' => sub {
            it 'should switch the HTTP API URL for a websocket one' => sub {
                is 'wss://my-mattermost-server.com/api/v4/websocket', $vars{app}->websocket_url;
            };
        };
    };

    describe 'ua' => sub {
        it 'should be an empty Mojo::Log, not the API UA' => sub {
            is 'Mojo::UserAgent', ref $vars{app}->ua;
            isnt 'WebService::Mattermost::Util::UserAgent', ref $vars{app}->{ua};
        };
    };

    describe 'start' => sub {
        it 'should open a WebSocket connection' => sub {
            Mojo::UserAgent
                ->expects('websocket')
                ->once;

            $vars{app}->start;

            ok 1;
        };

        describe 'debugging enabled' => sub {
            it 'should log connection information' => sub {
                SKIP: {
                    skip 'Test not yet complete', 1;
                    ok 1;
                };
            };
        };

        describe 'debugging disabled' => sub {
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

    describe 'message_has_content' => sub {
        it 'return the message if it exists' => sub {
            is $vars{app}->message_has_content({ post_data => { message => 'Yay!' } }), 'Yay!';
        };

        it 'should return undef if there is no post_content' => sub {
            is $vars{app}->message_has_content({}), undef;
        };

        it 'should return undef if post_content has no message' => sub {
            is $vars{app}->message_has_content({ post_content => {} }), undef;
        };
    };
};

runtests unless caller;

