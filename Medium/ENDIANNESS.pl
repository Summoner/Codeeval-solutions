#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper; 
use Benchmark;
 use Config;
my $t0 = new Benchmark;


my @arr = split //,$Config{byteorder};

if ($arr[0] == 1){

	print "LittleEndian\n";

}elsif($arr[0] == 4 || $arr[0] == 8){

	print "BigEndian\n";
} 



my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
