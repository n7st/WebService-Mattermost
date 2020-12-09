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

    it 'should attach the logger role to the consumer' => sub {
        ok $vars{app}->DOES('WebService::Mattermost::Role::Logger');
    };

    describe '#logger' => sub {
        it 'should be an instance of Mojo::Log' => sub {
            is 'Mojo::Log', ref $vars{app}->logger;
        };
    };
};

runtests unless caller;

