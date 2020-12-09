#!/usr/bin/env perl -T

use Test::Spec;

use WebService::Mattermost::Util::UserAgent;

use constant {
    EXPECTED_MAX_REDIRECTS      => 5,
    EXPECTED_INACTIVITY_TIMEOUT => 15,
};

describe 'WebService::Mattermost::Util::UserAgent' => sub {
    share my %vars;

    before each => sub {
        $vars{app} = WebService::Mattermost::Util::UserAgent->new();
    };

    describe '#ua' => sub {
        it 'should be an instance of Mojo::UserAgent' => sub {
            is 'Mojo::UserAgent', ref $vars{app}->ua;
        };

        it 'should have max_redirects set to 5' => sub {
            is EXPECTED_MAX_REDIRECTS, $vars{app}->ua->max_redirects;
        };

        it 'should have inactivity_timeout set to 15' => sub {
            is EXPECTED_INACTIVITY_TIMEOUT, $vars{app}->ua->inactivity_timeout;
        };
    };
};

runtests unless caller;

