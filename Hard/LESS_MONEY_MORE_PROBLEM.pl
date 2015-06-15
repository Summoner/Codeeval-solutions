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
	push @list, [split /\s+\|\s+/,$_];

}
close $input;

foreach my $arr ( @list ){
    print solve( $arr->[0],$arr->[1],$arr->[2] ),"\n";
}

sub solve {
    my	( $c,$v,$coinsStr )	= @_;
    my @coins = split '\s+',$coinsStr;
    @coins = sort { $b <=> $a }@coins;
    my $coinsCount = 0;
    for ( my $i = 1; $i <= $v; $i++ ) {

        my $newCoin = calc( $c,$i,\@coins );
        unless ( $newCoin == 0 ){
            push @coins,$newCoin;
            $coinsCount++;
            @coins = sort { $b <=> $a }@coins;
        }
    }
    return $coinsCount;
} ## --- end sub solve


sub calc {
    my	( $c,$v,$coinsRef )	= @_;
    my @coins = @$coinsRef;
    my $num = $v;
    my $i = 0;
    my $coinsCount = 0;

    while ( $i <= $#coins ){

        if ( $coins[$i] > $num ){
            $i++;
            next;
        }
        $coinsCount++;
        if ( $coinsCount == $c ){
            $num -= $coins[$i];
            $coinsCount = 0;
            $i++;
        }else{
            $num -= $coins[$i];
        }
    }
    return $v unless ( $num == 0 );
    return 0;
} ## --- end sub calc

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
