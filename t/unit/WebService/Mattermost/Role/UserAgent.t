#!/usr/bin/env perl -T

use Test::Spec;

package UserAgentConsumer {
    use Moo;

    with 'WebService::Mattermost::Role::UserAgent';

    1;
};

describe 'WebService::Mattermost::Role::UserAgent' => sub {
    share my %vars;

    before each => sub {
        $vars{app} = UserAgentConsumer->new();
    };

    it 'should attach the user agent to the consumer' => sub {
        can_ok $vars{app}, 'ua';
        ok $vars{app}->DOES('WebService::Mattermost::Role::UserAgent');
        is 'Mojo::UserAgent', ref $vars{app}->ua;
    };
};

runtests unless caller;

