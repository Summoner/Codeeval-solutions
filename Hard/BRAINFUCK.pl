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
	    push @list, [split //,$_];
	}
close $input;

my $lookupTable = {

    "\>" => \&IncrementCurrentCellIndex,
    "\<" => \&DecrementCurrentCellIndex,
    "\+" => \&IncrementCurrentCellValue,
    "\-" => \&DecrementCurrentCellValue,
    "\." => \&OutputCurrentCellValue,
    "\," => \&InputCurrentCellValue,
    "\[" => \&HandleLeftBracket,
    "\]" => \&HandleRightBracket,
};

my $bracketsPairs = [];

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

   print calc( $arr ),"\n";
}

sub calc {
    my	( $arr )	= @_;
    my $cells = [];
    my $currentCell = 0;
    my $index = 0;
    my $currentSymbol = undef;
    $bracketsPairs = CreateBracketsPairs( $arr );
  
    #print Dumper \$bracketsPairs;
    while ( $index <= $#{$arr} ) {
        my $currentSymbol = $arr->[$index];
        ( $cells,$currentCell,$index ) = $lookupTable->{$currentSymbol}->( $cells, $currentCell, $index );
        $index++;
    }    
} ## --- end sub calc


sub CreateBracketsPairs {
    my	( $arr )	= @_;
    my $bracketsStack = [];
    my $bracketsPairs = [];

    #Find all brackets and push them in stack with their indexes
    for ( my $i = 0; $i <= $#{$arr}; $i++ ) {
        my $symbol = $arr->[$i];

        if ( $symbol eq "[" ){

            my $openBracket = {};
            $openBracket->{value} = $symbol;
            $openBracket->{openIndex} = $i; 
            push @$bracketsStack, $openBracket;

        }elsif( $symbol eq "]" ){

            my $closeBracket = {};
            my $openBracket = pop @$bracketsStack;

            $closeBracket->{value} = $symbol;
            $closeBracket->{openIndex} = $openBracket->{openIndex};
            $closeBracket->{closeIndex} = $i;

            $openBracket->{closeIndex} = $closeBracket->{closeIndex};
            push @$bracketsPairs, ($openBracket,$closeBracket);                        
        }
    }
    return $bracketsPairs;
} ## --- end sub CreateBracketsPairs

sub IncrementCurrentCellIndex {
    my	( $cells,$currentCell,$index )	= @_;
    $currentCell++;
    return ( $cells,$currentCell,$index );
} ## --- end sub IncrementCurrentCellIndex

sub DecrementCurrentCellIndex {
    my	( $cells,$currentCell,$index )	= @_;
    $currentCell--;
    return ( $cells,$currentCell,$index );
} ## --- end sub DecrementCurrentCellIndex

sub IncrementCurrentCellValue {
    my	( $cells,$currentCell,$index )	= @_;
    $cells->[$currentCell]++;
    return ( $cells,$currentCell,$index );
} ## --- end sub IncrementCurrentCellValue

sub DecrementCurrentCellValue {
    my	( $cells,$currentCell,$index )	= @_;
    $cells->[$currentCell]--;
    return ( $cells,$currentCell,$index );
} ## --- end sub DecrementCurrentCellValue

sub InputCurrentCellValue{
    my	( $cells,$currentCell,$value,$index )	= @_;
        $cells->[$currentCell] = $value;
    return ( $cells,$currentCell,$index );
} ## --- end sub InputCurrentCellValue

sub OutputCurrentCellValue{
    my	( $cells,$currentCell,$index )	= @_;
    #return $cells->[$currentCell];
    my $anciiCode = $cells->[$currentCell];
    print $Ansii2Char{ $anciiCode };
    return ( $cells,$currentCell,$index );
} ## --- end sub OutputCurrentCellValue

sub HandleLeftBracket {
    my	( $cells,$currentCell,$index )	= @_;

    if ( defined $cells->[$currentCell] && $cells->[$currentCell] == 0 ){
        my @brackets = grep{ $_->{value} eq "\]" && $_->{openIndex} == $index }@$bracketsPairs;
        my $rightBracket = $brackets[0];
        $index = $rightBracket->{closeIndex};
    }
    return ( $cells,$currentCell,$index );
} ## --- end sub HandleLeftBracket

sub HandleRightBracket {
    my	( $cells,$currentCell,$index )	= @_;

    if ( defined $cells->[$currentCell] && $cells->[$currentCell] != 0 ){
        my @brackets = grep{ $_->{value} eq "\[" && $_->{closeIndex} == $index }@$bracketsPairs;
        my $leftBracket = $brackets[0];
        $index = $leftBracket->{openIndex};
    }
    return ( $cells,$currentCell,$index );
} ## --- end sub HandleRightBracket

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
