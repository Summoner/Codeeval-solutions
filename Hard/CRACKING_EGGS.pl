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
       push @list, [split /\s+/,$_];
	}
close $input;


foreach my $arr ( @list ) {

    print calc( $arr->[0],$arr->[1] ),"\n";
}


sub count {
    my	( $eggs,$dropsCount )	= @_;

    return 0 if ( $eggs == 0 );

    my $result = 0;
    for ( my $i=0; $i < $dropsCount; $i++ ) {

        $result += count($eggs - 1,$i) +1;
    }
    return $result;
} ## --- end sub count

sub calc {
    my	( $eggs,$floors )	= @_;

    my $dropsCount = 0;
    while ( count( $eggs, $dropsCount ) < $floors ){

        $dropsCount++;

    }
    return $dropsCount;

} ## --- end sub calc


my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
