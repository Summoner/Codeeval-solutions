#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper;
use Benchmark;

my $t0 = new Benchmark;

  open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
 #open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";

my @list = ();

	while(<$input>){
    	chomp;
	    push @list,[split /\s+/,$_];
	}
close $input;

foreach my $arr ( @list ) {
    print Calc( $arr->[0],$arr->[1] ),"\n";
}

sub Calc {
    my	( $num,$n )	= @_;

    my $cycle = CreateCycle( $num );
    my $digits = {};
    my $cyclesCount = int( $n / scalar @{ $cycle } );

    my $rem = int( $n - $cyclesCount * scalar @{ $cycle } );

    foreach my $digit ( @{ $cycle } ) {
        $digits->{$digit} = $cyclesCount;
    }

    for ( my $i = 1; $i < int( $rem + 1 ); $i++ ) {
        my $digit = $cycle->[ int($i-1)%scalar @{ $cycle } ];
        $digits->{$digit}++;
    }

    foreach my $digit ( 0..9 ) {
        unless ( exists $digits->{$digit} ){
            $digits->{$digit} = 0;
        }
    }
    my @final = map{ join ": ",($_,$digits->{$_}) } sort{ $a <=> $b } keys %{ $digits };

    return join ", ",@final;
} ## --- end sub Calc

sub CreateCycle {
    my	( $num )	= @_;
    my $cycle = {};
    my $cycles = [];
    my $current = $num;

    while ( !exists $cycle->{$current} ){

        $cycle->{$current} = 1;
        push @$cycles,$current;
        $current = ($current * $num)%10;
    }
    return $cycles;
} ## --- end sub CreateCycle

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
