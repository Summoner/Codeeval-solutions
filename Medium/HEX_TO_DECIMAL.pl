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


foreach my $number ( @list ) {

print hexToDec( $number ),"\n";
}

sub hexToDec {
    my	( $hexData )	= @_;

    my $res = sprintf( "%d",hex($hexData) ); 
    return $res;
} ## --- end sub hexToBin

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
