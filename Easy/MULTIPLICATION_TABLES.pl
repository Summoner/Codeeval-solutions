#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper;
use Benchmark;

my $t0 = new Benchmark;

show_matrix();

sub show_matrix {

    my $matrix = [];

    for ( my $i=0; $i<12; $i++ ) {

        $matrix->[$i]->[0] = $i+1;
    }

    for ( my $i=0;$i < 12; $i++ ) {

        for ( my $j=1;$j < 12; $j++ ) {

            $matrix->[$i]->[$j] = sprintf ("%4d", ($matrix->[$i]->[$j-1] + $matrix->[$i]->[0]));
        }
    }

    for ( my $i=0;$i < 12; $i++ ) {

        for ( my $j=0;$j < 12; $j++ ) {

            print $matrix->[$i]->[$j];
        }
        print "\n";
    }
} ## --- end sub show_matrix


my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
