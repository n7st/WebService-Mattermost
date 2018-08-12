#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use Test::Most tests => 2;

use lib "$FindBin::RealBin/../lib";

use Net::Mattermost::Helper::Alias qw(v4 util);

is util('Hello'), 'Net::Mattermost::Util::Hello', 'Util alias helper success';
is v4('Hello'),   'Net::Mattermost::API::v4::Resource::Hello', 'v4 alias helper success';

