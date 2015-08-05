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
	    push @list,[split /\s+/, $_];
	}
close $input;

my %Char2Ansii = (
    " " => 32,
    "!" => 33,
    "\""=> 34,
    "#" => 35,
    "\$"=> 36,
    "%" => 37,
    "&" => 38,
    "'" => 39,
    "(" => 40,
    ")" => 41,
    "*" => 42,
    "+" => 43,
    "\,"=> 44,
    "\-"=> 45,
    "\."=> 46,
    "/" => 47,
    "0" => 48,
    "1" => 49,
    "2" => 50,
    "3" => 51,
    "4" => 52,
    "5" => 53,
    "6" => 54,
    "7" => 55,
    "8" => 56,
    "9" => 57,
    ":" => 58,
    ";" => 59,
    "<" => 60,
    "=" => 61,
    ">" => 62,
    "?" => 63,
    "@" => 64,
    "A" => 65,
    "B" => 66,
    "C" => 67,
    "D" => 68,
    "E" => 69,
    "F" => 70,
    "G" => 71,
    "H" => 72,
    "I" => 73,
    "J" => 74,
    "K" => 75,
    "L" => 76,
    "M" => 77,
    "N" => 78,
    "O" => 79,
    "P" => 80,
    "Q" => 81,
    "R" => 82,
    "S" => 83,
    "T" => 84,
    "U" => 85,
    "V" => 86,
    "W" => 87,
    "X" => 88,
    "Y" => 89,
    "Z" => 90,
    "[" => 91,
    "\\"=> 92,
    "]" => 93,
    "\^"=> 94,
    "\_"=> 95,
    "\`"=> 96,
    "a" => 97,
    "b" => 98,
    "c" => 99,
    "d" => 100,
    "e" => 101,
    "f" => 102,
    "g" => 103,
    "h" => 104,
    "i" => 105,
    "j" => 106,
    "k" => 107,
    "l" => 108,
    "m" => 109,
    "n" => 110,
    "o" => 111,
    "p" => 112,
    "q" => 113,
    "r" => 114,
    "s" => 115,
    "t" => 116,
    "u" => 117,
    "v" => 118,
    "w" => 119,
    "x" => 120,
    "y" => 121,
    "z" => 122
);

my %Ansii2Char = reverse %Char2Ansii;


foreach my $arr ( @list ) {

    calc( $arr );
}


sub calc {
    my	( $arr )	= @_;
    my $wordLength = shift @$arr;
    #get rid of | symbol
    shift @$arr;
    my $wordLastLetter = shift @$arr;
    #get rid of | symbol
    shift @$arr;
    #adding spaces
    $wordLength += 2;
    my $duplicates = [];

    for ( my $i = 0; $i <= scalar @$arr - ( $wordLength + $wordLength ); $i ++ ) {
        for ( my $j = $i + $wordLength; $j <= scalar @$arr - $wordLength; $j ++ ) {

            my @arr1 = map{ $arr->[$_] }$i..$i+$wordLength-1;
            my @arr2 = map{ $arr->[$_] }$j..$j+$wordLength-1;
            if ( areArraysEqual( \@arr1,\@arr2 ) ){
                push @$duplicates,\@arr1;
            }
        }
    }
    findMessage( $duplicates,$wordLastLetter,$arr );
} ## --- end sub calc

sub findMessage {
    my	( $duplicates,$wordLastLetter,$fullMessage )	= @_;
#$DB::single = 2;
    my $possibleWords = [];
    foreach my $arr ( @$duplicates ) {
        if ( $arr->[0] == $arr->[-1] ){
            #possible word with spaces on both sides
            shift @$arr;
            pop @$arr;
            push @$possibleWords ,$arr;
        }
    }
    if ( scalar @$possibleWords == 1){
        my $possibleWord = $possibleWords->[0];
        my $wordLastLetterCode = $possibleWord->[-1];
        my $wordLastLetterAnciiCode = $Char2Ansii{$wordLastLetter};
        my $difference = $wordLastLetterCode - $wordLastLetterAnciiCode;
        my $fullMessageinAncii = [];

        foreach my $code ( @$fullMessage ) {
            my $codeInAncii = $code - $difference;
            push @$fullMessageinAncii,$codeInAncii;
        }
        my $decodedSymbols = [];
#        print join " ",@$fullMessageinAncii,"\n";
        foreach my $code ( @$fullMessageinAncii ) {
            if ( exists $Ansii2Char{$code} ){
                push @$decodedSymbols, $Ansii2Char{$code};
            }else{
                print "$code didn't exist in table\n";
            }
        }
        print join "",@$decodedSymbols,"\n";
    }else{
    print "We have more than 1 variant\n";
    }
} ## --- end sub findMessage

sub areArraysEqual {
    my	( $arr1,$arr2 )	= @_;
    my $areEqual = 1;

    for ( my $i = 0; $i <= $#{$arr1};$i++ ) {
        unless ( $arr1->[$i] == $arr2->[$i] ){
            $areEqual = 0;
            last;
        }
    }
    return $areEqual;
} ## --- end sub compareArrays


my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
