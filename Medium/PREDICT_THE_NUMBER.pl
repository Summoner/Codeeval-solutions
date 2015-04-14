#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper;
#use bigint;
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

foreach my $position (@list){

   print calc( $position ),"\n";
}

sub calc {
    my	( $number )	= @_;

    if ( $number >= 0 && $number <= 3000000000 ){
    
        my $bin = sprintf( "%b",$number );
        my @bits = split //,$bin;
        my $summ = 0;

        foreach my $bit ( @bits ) {
            
            $summ++ if ( $bit == 1 );
        }
        return $summ % 3;
    }
}


my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
