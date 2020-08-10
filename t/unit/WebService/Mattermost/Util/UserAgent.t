#!/usr/bin/env perl -T

use Test::Spec;

use WebService::Mattermost::Util::UserAgent;

describe 'WebService::Mattermost::Util::UserAgent' => sub {
    share my %vars;

    before each => sub {
        $vars{app} = WebService::Mattermost::Util::UserAgent->new();
    };

    describe 'ua' => sub {
        it 'should be an instance of Mojo::UserAgent' => sub {
            is 'Mojo::UserAgent', ref $vars{app}->ua;
        };

        it 'should have max_redirects set to 5' => sub {
            is 5, $vars{app}->ua->max_redirects;
        };

        it 'should have inactivity_timeout set to 15' => sub {
            is 15, $vars{app}->ua->inactivity_timeout;
        };
    };
};

runtests unless caller;

