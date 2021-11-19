#!/usr/bin/env perl -T

use Test::Spec;

require 'test_helper.pl';

describe 'WebService::Mattermost::V4::API::Object::Team' => sub {
    share my %vars;

    describe '#channels' => sub {
        before all => sub {
            $vars{team} = WebService::Mattermost::V4::API::Object::Team->new({
                auth_token => AUTH_TOKEN(),
                base_url   => BASE_URL(),
                raw_data   => { id => 'my-test-team-id' },
            });
        };

        it 'is an instance of WebService::Mattermost::V4::API::Resource::Team::Channels' => sub {
            isa_ok $vars{team}->channels, 'WebService::Mattermost::V4::API::Resource::Team::Channels';
        };

        it 'was built with the team ID' => sub {
            is $vars{team}->channels->id, 'my-test-team-id';
        };

        it 'has the expected available methods' => sub {
            my $ok = 1;

            foreach my $method (qw(public by_ids deleted autocomplete search by_name_and_team_name by_name)) {
                $ok = 0 unless $vars{team}->channels->can($method);
            }

            ok $ok;
        };
    };
};

runtests unless caller;