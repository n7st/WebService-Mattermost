#!/usr/bin/env perl

use strict;
use warnings;

################################################################################

sub mojo_response {
    my $args = shift || {};

    return Mojo::Message::Response->new(%{$args});
}

sub mojo_tx {
    return Mojo::Transaction::HTTP->new(res => mojo_response({
        code    => 200,
        message => 'OK',
    }));
}

sub mojo_url {
    my $endpoint = shift;

    return Mojo::URL->new(sprintf('%s%s', BASE_URL, $endpoint));
}

################################################################################

1;