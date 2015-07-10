#!/usr/bin/perl

use strict;
use warnings;

use Test::More "no_plan";

use_ok( 'FileStatsTool' ); # Easy to test importing the module

my $ma= FileStatsTool->new();

##Test of new()
#Much Cleaner! (third argument is what to call the object)
isa_ok($ma, 'FileStatsTool', 'ma');

eval{$ma->getFileStats() };
like($@, qr/Directory Path is not a valid/,"Directory Path is mandatory to pass");
eval{$ma->getFileStats('/v/global/user/g/go/gopaladd')};
like($@, qr/cannot open directory/,"cannot open directory");
eval{$ma->getFileStats('./')};
like($@, qr/No text file present in directory/,"No text file present in directory");
eval{$ma->displayStat()};
like($@, qr/No File Stats To Display/,"No File Stats To Display");

my $expected_complex_structure=$ma->getFileStats('./');
cmp_ok(ref $ma->getFileStats('./'), 'eq' ,ref $expected_complex_structure,'File stats generated successfully');

my $expected_display=$ma->displayStat();
cmp_ok($ma->displayStat(),'eq',$expected_display,'output matched');



