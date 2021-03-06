#!/usr/bin/env perl -t

use Moose::Util 'apply_all_roles';
use Test::Exception;
use Test::Spec;

package EmptyRequireIDConsumer { use Moose; };

package RequireIDConsumer {
    use Moose;

    with qw(
        WebService::Mattermost::Role::Returns
        WebService::Mattermost::V4::API::Role::RequireID
    );

    sub done {
        my $self = shift;
        my $id   = shift;

        return 1;
    }
};

describe 'WebService::Mattermost::V4::API::Role::RequireID' => sub {
    share my %vars;

    before each => sub {
        $vars{app} = RequireIDConsumer->new();
    };

    describe 'role validation' => sub {
        before each => sub { $vars{app} = EmptyRequireIDConsumer->new(); };

        context 'with the required additional role' => sub {
            it 'should not throw a missing method error' => sub {
                lives_ok {
                    apply_all_roles($vars{app}, qw(
                        WebService::Mattermost::Role::Returns
                        WebService::Mattermost::V4::API::Role::RequireID
                    ));
                };
            };
        };

        context 'without the required additional role' => sub {
            it 'should throw a missing method error' => sub {
                throws_ok {
                    apply_all_roles($vars{app},
                        'WebService::Mattermost::V4::API::Role::RequireID');
                } qr{requires the method 'error_return'};
            };
        };
    };

    describe '#validate_id' => sub {
        context 'with a valid UUID' => sub {
            it 'run the next method in the chain' => sub {
                my $id          = '18abe71f-ab63-4dbf-bd01-6aa60e7bb396';
                my $next_method = 'done';

                RequireIDConsumer->expects($next_method)->with($id)->once;

                $vars{app}->validate_id($next_method, $id);

                ok 1;
            };
        };

        context 'with an invalid UUID' => sub {
            it 'should return an error' => sub {
                is_deeply {
                    error   => 1,
                    message => 'Invalid or missing ID parameter. No API query was made.',
                }, $vars{app}->validate_id('done', 'a bad ID');
            };
        };
    };
};

runtests unless caller;

