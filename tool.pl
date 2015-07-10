#!/usr/bin/perl

use strict;
use warnings;


use FileStatsTool; # Easy to test importing the module

my $ma= FileStatsTool->new();
use Data::Dumper;
print Dumper($ma->getFileStats('/home/nisdev/www/fasteners/'));




