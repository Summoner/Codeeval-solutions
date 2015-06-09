#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper;
use Benchmark;

my $t0 = new Benchmark;

open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
# open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";

my @list = ();
my %alphabet = ();
$alphabet{1} = "A";
$alphabet{2} = "B";
$alphabet{3} = "C";
$alphabet{4} = "D";
$alphabet{5} = "E";
$alphabet{6} = "F";
$alphabet{7} = "G";
$alphabet{8} = "H";
$alphabet{9} = "I";
$alphabet{10} = "J";
$alphabet{11} = "K";
$alphabet{12} = "L";
$alphabet{13} = "M";
$alphabet{14} = "N";
$alphabet{15} = "O";
$alphabet{16} = "P";
$alphabet{17} = "Q";
$alphabet{18} = "R";
$alphabet{19} = "S";
$alphabet{20} = "T";
$alphabet{21} = "U";
$alphabet{22} = "V";
$alphabet{23} = "W";
$alphabet{24} = "X";
$alphabet{25} = "Y";
$alphabet{26} = "Z";

while(<$input>){
	chomp;
	push @list,$_;
}
close $input;

foreach (@list){

    my @letters = ();
    deep( $_,\@letters );
    print join "",@letters,"\n";
}

sub deep {
    my	( $number,$letters )	= @_;

    if ( $number <= 26 ){
        unshift @$letters, $alphabet{$number};
        return;
    }
    my $mainNumber = int $number / 26;
    my $remainder = $number % 26;

    if ( $remainder == 0 ){
        unshift @$letters,$alphabet{26};
        deep( $mainNumber-1,$letters );
    }else{
        unshift @$letters,$alphabet{$remainder};
        deep( $mainNumber,$letters );
    }
    return $letters;
} ## --- end sub deep

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
