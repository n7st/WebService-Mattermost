#!/usr/bin/env perl -T

use Test::Spec;

use WebService::Mattermost::Util::Logger;

describe 'WebService::Mattermost::Util::Logger' => sub {
    share my %vars;

    before each => sub {
        $vars{app} = WebService::Mattermost::Util::Logger->new();
    };

    describe 'logger' => sub {
        it 'should be an instance of Mojo::Log' => sub {
            is 'Mojo::Log', ref $vars{app}->logger;
        };

        describe 'debugf' => sub {
            it 'should format arguments in a debug message' => sub {
                send_monkey_patched_method($vars{app}, 'debug');
            };
        };

        describe 'infof' => sub {
            it 'should format arguments in a info message' => sub {
                send_monkey_patched_method($vars{app}, 'info');
            };
        };

        describe 'fatalf' => sub {
            it 'should format arguments in a fatal message' => sub {
                send_monkey_patched_method($vars{app}, 'fatal');
            };
        };

        describe 'warnf' => sub {
            it 'should format arguments in a warn message' => sub {
                send_monkey_patched_method($vars{app}, 'warn');
            };
        };
    };
};

runtests unless caller;

sub send_monkey_patched_method {
    my $app    = shift;
    my $method = shift;

    Mojo::Log->expects($method)->with('Hello, world')->once;

    my $sprintf_method = "${method}f";

    $app->logger->$sprintf_method('Hello, %s', 'world');

    ok 1;

    return 1;
}

