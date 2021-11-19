#!/usr/bin/env perl -T

use Test::Spec;

use lib 't';

require 'test_helper.pl';

describe 'WebService::Mattermost::V4::API::Resource::Team::Channels' => sub {
    share my %vars;

    describe '#public' => sub {
        context 'with an "id" attribute set' => sub {
            before all => sub {
                $vars{get_request} = {
                    class_method_closure => sub {
                        my $team_channels = shift->api->team_channels;

                        $team_channels->id('my-team-id-attribute');

                        return $team_channels->public;
                    },
                    url                  => '/team/my-team-id-attribute/channels',
                    resource             => 'team_channels',
                };
            };

            it_should_behave_like 'a GET API endpoint';
        };

        context 'with an "id" variable passed' => sub {
            before all => sub {
                $vars{get_request} = {
                    class_method_closure => sub { shift->api->team_channels->public('my-team-id-variable') },
                    url                  => '/team/my-team-id-variable/channels',
                    resource             => 'team_channels',
                };
            };

            it_should_behave_like 'a GET API endpoint';
        };
    };
};

runtests unless caller;