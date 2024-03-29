#!/usr/bin/env perl -T

use Test::Spec;

use lib 't';

require 'test_helper.pl';

describe 'WebService::Mattermost::V4::API::Resource::Brand' => sub {
    share my %vars;

    describe '#current' => sub {
        before all => sub {
            $vars{get_request} = {
                class_method_closure => sub { return shift->api->brand->current },
                url                  => '/brand/image',
                resource             => 'brand',
            };
        };

        it_should_behave_like 'a GET API endpoint';
    };

    describe '#upload' => sub {
        before all => sub {
            my $filename = 'my-nice-new-image.png';

            $vars{post_request} = {
                assembled_form_type       => 'form',
                assembled_parameters      => { image => { file => $filename } },
                class_method_closure      => sub { return shift->api->brand->upload(shift) },
                class_method_closure_args => $filename,
                resource                  => 'brand',
                url                       => '/brand/image',
            };
        };

        it_should_behave_like 'a POST API endpoint';
    };
};

runtests unless caller;