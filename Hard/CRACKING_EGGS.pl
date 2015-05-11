#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper;
use Benchmark;
#use bigint;

my $t0 = new Benchmark;

  open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
 #open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";

my @list = ();

	while(<$input>){
    	chomp;

	}
close $input;







sub calc {
    my	( $eggs,$floors )	= @_;

    my $matrix = [];

    for ( my $i = 0; $i <= $eggs; $i++ ) {

        for ( my $j = 0; $j <= $floors; $j++ ) {

            $matrix->[$i]->[$j] = 0;
        }
    }
    
    for ( my $i = 1; $i <= $floors; $i++ ) {

        $matrix->[1]->[$i] = $i;
    }
    for ( my $j = 1; $j <= $eggs; $j++ ) {

        $matrix->[$j]->[1] = 1;
    }



    return ;
} ## --- end sub calc


my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
