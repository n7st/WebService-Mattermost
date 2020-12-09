#!/usr/bin/env perl -T

use Test::Spec;

package ReturnsConsumer {
    use Moo;

    with 'WebService::Mattermost::Role::Returns';

    1;
};

describe 'WebService::Mattermost::Role::Returns' => sub {
    share my %vars;

    before each => sub {
        $vars{app} = ReturnsConsumer->new();
    };

    it 'should attach the returns role to the consumer' => sub {
        ok $vars{app}->DOES('WebService::Mattermost::Role::Returns');
    };

    describe '#error_return' => sub {
        it 'should format an error hash' => sub {
            is_deeply {
                error   => 1,
                message => 'Bad error. No API query was made.',
            }, $vars{app}->error_return('Bad error');
        };
    };
};

runtests unless caller;

