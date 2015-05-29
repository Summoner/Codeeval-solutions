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
        push @list,[split //,lc $_];
	}
close $input;

my %alphabet = ();

$alphabet{a} = 1;
$alphabet{b} = 2;
$alphabet{c} = 3;
$alphabet{d} = 4;
$alphabet{e} = 5;
$alphabet{f} = 6;
$alphabet{g} = 7;
$alphabet{h} = 8;
$alphabet{i} = 9;
$alphabet{j} = 10;
$alphabet{k} = 11;
$alphabet{l} = 12;
$alphabet{m} = 13;
$alphabet{n} = 14;
$alphabet{o} = 15;
$alphabet{p} = 16;
$alphabet{q} = 17;
$alphabet{r} = 18;
$alphabet{s} = 19;
$alphabet{t} = 20;
$alphabet{u} = 21;
$alphabet{v} = 22;
$alphabet{w} = 23;
$alphabet{x} = 24;
$alphabet{y} = 25;
$alphabet{z} = 26;

#print Dumper \@list;
foreach my $arr ( @list ) {
    print calc( $arr ),"\n";
}

sub calc {
    my	( $str )	= @_;
    my %letters = ();
    my $result = 0;
    my $beautyCoeff = 26;
    foreach my $letter ( @$str ) {
        next unless defined ( $alphabet{$letter} );
        $letters{$letter}++;
    }
    my @sortedByAppearance = sort { $letters{$b} <=> $letters{$a} }keys %letters;
    foreach my $letter ( @sortedByAppearance ) {
        my $beauty = $beautyCoeff * $letters{$letter};
        $result += $beauty;
        $beautyCoeff--; 
    }
    return $result;
} ## --- end sub calc

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
