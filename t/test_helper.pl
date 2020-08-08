#!/usr/bin/env perl

use strict;
use warnings;

use Test::Most;

use WebService::Mattermost::V4::API::Resource::Users;
use WebService::Mattermost::V4::API::Response;

sub base_url { 'https://my-mattermost-server.com/api/v4/' }

sub client_arguments {
    my $extra = shift || {};

    return {
        authenticate => 1,
        base_url     => base_url(),
        password     => 'mypassword',
        username     => 'myusername',

        %{$extra},
    };
}

sub response {
    my $args = shift || {};

    my $headers = Mojo::Headers->new();

    $headers->add(token => 'whatever');

    return WebService::Mattermost::V4::API::Response->new({
        content    => { id => 'asd1234' },
        base_url   => 'wherever',
        auth_token => 'whatever',
        code       => 200,
        headers    => $headers,
        prev       => Mojo::Message::Response->new(),

        %{$args},
    });
}

sub user_resource_expects_login {
    my $responds_with = shift;

    my $args = client_arguments();

    WebService::Mattermost::V4::API::Resource::Users
        ->stubs('login')
        ->with($args->{username}, $args->{password})
        ->once
        ->returns($responds_with);
}

1;
