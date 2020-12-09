#!/usr/bin/env perl -T

use Test::Spec;

use WebService::Mattermost;
use WebService::Mattermost::TestHelper qw(
    AUTH_TOKEN
    headers
    resource_url
    mojo_tx
    webservice_mattermost

    expects_api_call
    test_id_error
    test_single_response_of_type
);

describe 'WebService::Mattermost::V4::API::Resource::Bots' => sub {
    share my %vars;

    before each => sub {
        $vars{app} = webservice_mattermost({
            authenticate => 0,
            auth_token   => AUTH_TOKEN,
        });

        $vars{args} = {};
    };

    describe '#list' => sub {
        context 'with no search parameters' => sub {
            it 'sends a GET /bots request' => sub {
                test_sends_get_bots_request($vars{app});
            };

            it 'returns a list of bots' => sub {
                test_returns_list_of_bots($vars{app});
            };
        };

        context 'with search parameters' => sub {
            before each => sub {
                $vars{args} = {
                    page            => 1,
                    per_page        => 100,
                    include_deleted => 1,
                    only_orphaned   => 0,
                };
            };

            it 'sends a GET /bots request' => sub {
                test_sends_get_bots_request($vars{app}, $vars{args});
            };

            it 'returns a list of bots' => sub {
                test_returns_list_of_bots($vars{app}, $vars{args});
            };
        };
    };

    describe '#get' => sub {
        context 'with no ID' => sub {
            it 'returns a missing or invalid ID error' => sub {
                expects_bot_get_call($vars{app}, '!!!')->never;

                test_id_error($vars{app}->api->bots->get('!!!'));
            };
        };

        context 'with an invalid ID' => sub {
            it 'returns a missing or invalid ID error' => sub {
                expects_bot_get_call($vars{app}, '!!!')->never;

                test_id_error($vars{app}->api->bots->get);
            };
        };

        context 'with a valid ID and optional parameters' => sub {
            before each => sub {
                expects_bot_get_call($vars{app}, 'asd-123', {
                    include_deleted => 1,
                });
            };

            it 'sends a GET /bots/{id} request' => sub {
                ok $vars{app}->api->bots->get('asd-123', { include_deleted => 1 });
            };

            it 'returns a single bot' => sub {
                my $response = $vars{app}->api->bots->get('asd-123', {
                    include_deleted => 1,
                });

                test_single_response_of_type($response, 'WebService::Mattermost::V4::API::Object::Bot');
            };
        };
    };
};

runtests unless caller;

sub expects_bot_list_call {
    my $app  = shift;
    my $args = shift || {};

    return expects_api_call($app, {
        method     => 'get',
        resource   => 'bots',
        url        => '/bots',
        parameters => $args,
    });
}

sub expects_bot_get_call {
    my $app  = shift;
    my $id   = shift || q{};
    my $args = shift || {};

    return expects_api_call($app, {
        method     => 'get',
        resource   => 'bots',
        url        => "/bots/${id}",
        parameters => $args,
    });
}

sub test_returns_list_of_bots {
    my $app  = shift;
    my $args = shift || {};

    expects_bot_list_call($app, $args);

    my $response = $app->api->bots->list($args);

    foreach my $item (@{$response->items}) {
        is 'WebService::Mattermost::V4::API::Object::Bot', ref $item;
    }

    return 1;
}

sub test_sends_get_bots_request {
    my $app  = shift;
    my $args = shift || {};

    expects_bot_list_call($app, $args);

    ok $app->api->bots->list($args);

    return 1;
}
