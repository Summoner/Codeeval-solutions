#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper;
use Benchmark;

my $t0 = new Benchmark;
open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
# open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";



my @list = ();

    while(<$input>){
    chomp;
    push @list,$_;
	}
close $input;

#print Dumper \@list;
foreach my $val ( @list ) {

    print calc_fib($val),"\n";
}


sub calc_fib {
    my	( $n )	= @_;

    my %fib = ();
    $fib{0} = 0;
    $fib{1} = 1;


    foreach my $i ( 2..$n ) {

        $fib{$i} = $fib{$i-1} + $fib{$i-2};
    }

    return $fib{$n};
} ## --- end sub calc_fib
my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
