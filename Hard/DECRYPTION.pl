#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper; 
use Benchmark;

my $t0 = new Benchmark;

my $m = "012222 1114142503 0313012513 03141418192102 0113 2419182119021713 06131715070119";
my $k = "BHISOECRTMGWYVALUZDNFJKPQX";


my $count = 0;

my @key = split //,$k;
my @message = split /\s+/,$m;
my %mapp = ();
foreach my $symbol ( @key ) {

    $mapp{$symbol} = $count;
    $count++;
}

my $result = "";



foreach my $word ( @message ) {
    $result .= convert($word);
    $result .= " ";
}

print "$result\n";
sub convert {
    my	( $word )	= @_;

    my @word = split //,$word;
    my $converted = "";
    for ( my $i = 0; $i < $#word; $i+=2 ) {

        my $part = int( join "",($word[$i],$word[$i+1]) );
        $converted .= chr( ord("A") + $mapp{chr( ord("A") + $part)} );
    }
    return $converted;
} ## --- end sub convert




my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
