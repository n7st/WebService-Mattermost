#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;
use Test::Most tests => 2;

use lib "$FindBin::RealBin/../lib";

use WebService::Mattermost::Helper::Alias qw(v4 util);

is util('Hello'), 'WebService::Mattermost::Util::Hello', 'Util alias helper success';
is v4('Hello'),   'WebService::Mattermost::API::v4::Resource::Hello', 'v4 alias helper success';

