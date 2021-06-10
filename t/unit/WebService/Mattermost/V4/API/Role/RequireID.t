#!/usr/bin/env perl -T

use Test::Exception;
use Test::Spec;

package EmptyRequireIDConsumer { use Moo; };

package RequireIDConsumer {
    use Moo;

    with qw(
        WebService::Mattermost::Role::Returns
        WebService::Mattermost::V4::API::Role::RequireID
    );

    sub done {
        my $self = shift;
        my $id   = shift;

        return 1;
    }

    1;
};

describe 'WebService::Mattermost::V4::API::Role::RequireID' => sub {
    share my %vars;

    describe 'role validation' => sub {
        context 'with the required additional role' => sub {
            it 'should not throw a missing method error' => sub {
                lives_ok {
                    Moo::Role->apply_roles_to_package('RequireIDConsumer', qw(
                        WebService::Mattermost::Role::Returns
                        WebService::Mattermost::V4::API::Role::RequireID
                    ));

                    RequireIDConsumer->new();
                };
            };
        };

        context 'without the required additional role' => sub {
            it 'should throw a missing method error' => sub {
                throws_ok {
                    Moo::Role->apply_roles_to_package('EmptyRequireIDConsumer',
                        'WebService::Mattermost::V4::API::Role::RequireID');

                    EmptyRequireIDConsumer->new();
                } qr{missing error_return};
            };
        };
    };

    describe '#validate_id' => sub {
        before each => sub { $vars{app} = RequireIDConsumer->new(); };

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

