#!/usr/bin/env perl -T

use strict;
use warnings;

use Test::Pod;

my @pod_dirs = qw(lib t);

all_pod_files_ok(all_pod_files(@pod_dirs));

