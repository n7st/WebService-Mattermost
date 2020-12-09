#!/usr/bin/env perl -T

use Test::Exception;
use Test::Spec;

use WebService::Mattermost::Helper::Table;

describe 'WebService::Mattermost::Helper::Table' => sub {
    share my %vars;

    before each => sub { delete $vars{app} };

    describe '#table' => sub {
        context 'with no alignment settings' => sub {
            before each => sub {
                $vars{app} = WebService::Mattermost::Helper::Table->new({
                        headers   => [ qw(first second third) ],
                        values    => [
                            [ qw(r1-col1 r1-col2 r1-col3) ],
                            [ qw(r2-col1 r2-col2 r2-col3) ],
                            [ qw(r3-col1 r3-col2 r3-col3) ],
                            [ qw(r4-col1 r4-col2 r4-col3) ],
                        ]
                    });
            };

            it 'should convert the table to markdown with left aligned columns' => sub {
                my $expected = <<'TBL';
| first| second| third|
|:----|:----|:----|
|r1-col1|r1-col2|r1-col3|
|r2-col1|r2-col2|r2-col3|
|r3-col1|r3-col2|r3-col3|
|r4-col1|r4-col2|r4-col3|
TBL

                is $expected, $vars{app}->table;
            };
        };

        context 'with correct alignment settings' => sub {
            before each => sub {
                $vars{app} = WebService::Mattermost::Helper::Table->new({
                        alignment => [ qw(l c r) ],
                        headers   => [ qw(first second third) ],
                        values    => [
                            [ qw(r1-col1 r1-col2 r1-col3) ],
                            [ qw(r2-col1 r2-col2 r2-col3) ],
                            [ qw(r3-col1 r3-col2 r3-col3) ],
                            [ qw(r4-col1 r4-col2 r4-col3) ],
                        ]
                    });
            };

            it 'should convert the table to markdown with specified alignment' => sub {
                my $expected = <<'TBL';
| first| second| third|
|:----|:---:|----:|
|r1-col1|r1-col2|r1-col3|
|r2-col1|r2-col2|r2-col3|
|r3-col1|r3-col2|r3-col3|
|r4-col1|r4-col2|r4-col3|
TBL

                is $expected, $vars{app}->table;
            };
        };

        context 'with bad alignment settings' => sub {
            it 'should die' => sub {
                dies_ok {
                    WebService::Mattermost::Helper::Table->new({
                            alignment => [ qw(bad column alignment) ],
                            headers   => [ qw(first second third) ],
                            values    => [
                                [ qw(r1-col1 r1-col2 r1-col3) ],
                                [ qw(r2-col1 r2-col2 r2-col3) ],
                                [ qw(r3-col1 r3-col2 r3-col3) ],
                                [ qw(r4-col1 r4-col2 r4-col3) ],
                            ],
                        });
                } 'Passed bad names to alignment enum';
            };
        };
    };
};

runtests unless caller;
