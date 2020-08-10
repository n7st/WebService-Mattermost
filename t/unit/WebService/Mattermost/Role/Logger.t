#!/usr/bin/env perl -T

use Test::Spec;

package LoggerConsumer {
    use Moo;

    with 'WebService::Mattermost::Role::Logger';

    1;
};

describe 'WebService::Mattermost::Role::Logger' => sub {
    share my %vars;

    before each => sub {
        $vars{app} = LoggerConsumer->new();
    };

    it 'should attach the logger to the consumer' => sub {
        can_ok $vars{app}, 'logger';
        ok $vars{app}->DOES('WebService::Mattermost::Role::Logger');
        is 'Mojo::Log', ref $vars{app}->logger;
    };
};

runtests unless caller;

