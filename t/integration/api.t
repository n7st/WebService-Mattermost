#!/usr/bin/env perl

use FindBin;
use Mojo::URL;
use Test::Spec;

use WebService::Mattermost;

use WebService::Mattermost::TestHelper qw(
    client_arguments
    response
    user_resource_expects_login
);

describe 'API queries' => sub {
    share my %vars;

    before each => sub {
        user_resource_expects_login(response());

        delete $vars{app};
    };

    describe 'an unsuccessful API query' => sub {
        before each => sub {
            Mojo::UserAgent
                ->expects('post')
                ->with_deep(
                    Mojo::URL->new('https://my-mattermost-server.com/api/v4/posts') => {
                        'Authorization' => 'Bearer whatever',
                        'Keep-Alive'    => 1,
                    },
                    json => {
                        message    => 'Hello, world',
                        channel_id => 'my-channel-1',
                    },
                )
                ->returns(
                    Mojo::Transaction::HTTP->new(
                        res => Mojo::Message::Response->new(
                            message    => 'foo',
                            code       => 500,
                        ),
                    )
                );
        };

        describe 'with debugging enabled' => sub {
            before all => sub {
                $vars{app} = WebService::Mattermost->new(client_arguments({ debug => 1 }));
            };

            it 'should log a warning' => sub {
                $vars{app}->api->posts->logger
                    ->expects('warn')
                    ->with('An API error occurred: foo')
                    ->once;

                ok $vars{app}->api->posts->create({
                    message    => 'Hello, world',
                    channel_id => 'my-channel-1',
                });
            };
        };

        describe 'with debugging disabled' => sub {
            before all => sub {
                $vars{app} = WebService::Mattermost->new(client_arguments({ debug => 0 }));
            };

            it 'should not log a warning' => sub {
                $vars{app}->api->posts->logger
                    ->expects('warn')
                    ->with('An API error occurred: foo')
                    ->never;

                ok $vars{app}->api->posts->create({
                    message    => 'Hello, world',
                    channel_id => 'my-channel-1',
                });
            };
        };
    };
};

runtests unless caller;
