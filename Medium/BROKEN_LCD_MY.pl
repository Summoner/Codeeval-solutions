#!/usr/bin/perl -w

package Display;

sub new {
    my	$class 	= shift;
    my $self = {@_};

    bless $self,$class;
    return $self;
} ## --- end sub new

sub digit1 {
    $_[0]->{digit1} = $_[1] if defined $_[1]; return $_[0]->{digit1};
} ## --- end sub digit1

sub digit2 {
    $_[0]->{digit2} = $_[1] if defined $_[1]; return $_[0]->{digit2};
} ## --- end sub digit2

sub digit3 {
    $_[0]->{digit3} = $_[1] if defined $_[1]; return $_[0]->{digit3};
} ## --- end sub digit3

sub digit4 {
    $_[0]->{digit4} = $_[1] if defined $_[1]; return $_[0]->{digit4};
} ## --- end sub digit4

sub digit5 {
    $_[0]->{digit5} = $_[1] if defined $_[1]; return $_[0]->{digit5};
} ## --- end sub digit5

sub digit6 {
    $_[0]->{digit6} = $_[1] if defined $_[1]; return $_[0]->{digit6};
} ## --- end sub digit6

sub digit7 {
    $_[0]->{digit7} = $_[1] if defined $_[1]; return $_[0]->{digit7};
} ## --- end sub digit7

sub digit8 {
    $_[0]->{digit8} = $_[1] if defined $_[1]; return $_[0]->{digit8};
} ## --- end sub digit8

sub digit9 {
    $_[0]->{digit9} = $_[1] if defined $_[1]; return $_[0]->{digit9};
} ## --- end sub digit9

sub digit10 {
    $_[0]->{digit10} = $_[1] if defined $_[1]; return $_[0]->{digit10};
} ## --- end sub digit10

sub digit11 {
    $_[0]->{digit11} = $_[1] if defined $_[1]; return $_[0]->{digit11};
} ## --- end sub digit11

sub digit12 {
    $_[0]->{digit12} = $_[1] if defined $_[1]; return $_[0]->{digit12};
} ## --- end sub digit12


sub getDigitsInArray {
    my	( $self )	= @_;

    return [$self->digit1,
            $self->digit2,
            $self->digit3,
            $self->digit4,
            $self->digit5,
            $self->digit6,
            $self->digit7,
            $self->digit8,
            $self->digit9,
            $self->digit10,
            $self->digit11,
            $self->digit12
    ];
} ## --- end sub getDigitsInArray

package Digit;

sub new {
    my	$class 	= shift;
    my $self = {@_};

    bless $self,$class;
    return $self;
} ## --- end sub new

sub segment1 {
    $_[0]->{segment1} = $_[1] if defined $_[1]; return $_[0]->{segment1};
} ## --- end sub segment1

sub segment2 {
    $_[0]->{segment2} = $_[1] if defined $_[1]; return $_[0]->{segment2};
} ## --- end sub segment2

sub segment3 {
    $_[0]->{segment3} = $_[1] if defined $_[1]; return $_[0]->{segment3};
} ## --- end sub segment3

sub segment4 {
    $_[0]->{segment4} = $_[1] if defined $_[1]; return $_[0]->{segment4};
} ## --- end sub segment4

sub segment5 {
    $_[0]->{segment5} = $_[1] if defined $_[1]; return $_[0]->{segment5};
} ## --- end sub segment5

sub segment6 {
    $_[0]->{segment6} = $_[1] if defined $_[1]; return $_[0]->{segment6};
} ## --- end sub segment6

sub segment7 {
    $_[0]->{segment7} = $_[1] if defined $_[1]; return $_[0]->{segment7};
} ## --- end sub segment7

sub segment8 {
    $_[0]->{segment8} = $_[1] if defined $_[1]; return $_[0]->{segment8};
} ## --- end sub segment8

sub avaiableValues {
    my	( $self,$val )	= @_;

    # {0} = [1,1,1,1,1,1,0];
    # {1} = [0,1,1,0,0,0,0];
    # {2} = [1,1,0,1,1,0,1];
    # {3} = [1,1,1,1,0,0,1];
    # {4} = [0,1,1,0,0,1,1];
    # {5} = [1,0,1,1,0,1,1];
    # {6} = [1,0,1,1,1,1,1];
    # {7} = [1,1,1,0,0,0,0];
    # {8} = [1,1,1,1,1,1,1];
    # {9} = [1,1,1,1,0,1,1];

    return $self->{avaiableValues}->{$val} if ( defined $val );

    if ( $self->segment1 && $self->segment2 && $self->segment3 && $self->segment4 && $self->segment5 && $self->segment6 ){

        $self->{avaiableValues}->{0} = 1;
    }else{
        $self->{avaiableValues}->{0} = 0;
    }
    if ( $self->segment2 && $self->segment3 ){

        $self->{avaiableValues}->{1} = 1;
    }else{
        $self->{avaiableValues}->{1} = 0;
    }
    if ( $self->segment1 && $self->segment2 && $self->segment4 && $self->segment5 && $self->segment7 ){

        $self->{avaiableValues}->{2} = 1;
    }else{
        $self->{avaiableValues}->{2} = 0;
    }
    if ( $self->segment1 && $self->segment2 && $self->segment3 && $self->segment4 && $self->segment7 ){

        $self->{avaiableValues}->{3} = 1;
    }else{
        $self->{avaiableValues}->{3} = 0;
    }
    if ( $self->segment2 && $self->segment3 && $self->segment6 && $self->segment7 ){

        $self->{avaiableValues}->{4} = 1;
    }else{
        $self->{avaiableValues}->{4} = 0;
    }
    if ( $self->segment1 && $self->segment3 && $self->segment4 && $self->segment6 && $self->segment7 ){

        $self->{avaiableValues}->{5} = 1;
    }else{
        $self->{avaiableValues}->{5} = 0;
    }
    if ( $self->segment1 && $self->segment3 && $self->segment4 && $self->segment5 && $self->segment6 && $self->segment7 ){

        $self->{avaiableValues}->{6} = 1;
    }else{
        $self->{avaiableValues}->{6} = 0;
    }
    if ( $self->segment1 && $self->segment2 && $self->segment3 ){

        $self->{avaiableValues}->{7} = 1;
    }else{
        $self->{avaiableValues}->{7} = 0;
    }
    if ( $self->segment1 && $self->segment2 && $self->segment3 && $self->segment4 && $self->segment5 && $self->segment6 && $self->segment7){

        $self->{avaiableValues}->{8} = 1;
    }else{
        $self->{avaiableValues}->{8} = 0;
    }
    if ( $self->segment1 && $self->segment2 && $self->segment3 && $self->segment4 && $self->segment6 && $self->segment7 ){

         $self->{avaiableValues}->{9} = 1;
    }else{

        $self->{avaiableValues}->{9} = 0;
    }
    return $self;
} ## --- end sub avaiableValues

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
	    push @list,[split /;/,$_];
	}
close $input;

#print Dumper \@list;

foreach my $str (@list){

    print calc($str->[0],$str->[1]),"\n";
}

sub calc {
    my	( $lcd,$digitForShow )	= @_;
    my @inpBrokenDigits = split /\s+/,$lcd;
    my @brokenDigits = ();
    my $symbolsForShow = formSymbolsForShow( $digitForShow );

    return 0 if ( scalar @$symbolsForShow > scalar @inpBrokenDigits );

    foreach my $inpBrokenDigit ( @inpBrokenDigits ) {

        my @symbols = split //,$inpBrokenDigit;
        my $brokenDigit = Digit->new(   segment1 => $symbols[0],
                                        segment2 => $symbols[1],
                                        segment3 => $symbols[2],
                                        segment4 => $symbols[3],
                                        segment5 => $symbols[4],
                                        segment6 => $symbols[5],
                                        segment7 => $symbols[6],
                                        segment8 => $symbols[7]
                                    );
        #$DB::single = 2;
        $brokenDigit->avaiableValues();
        push @brokenDigits,$brokenDigit;
    }
    my $brokenDisplay = Display->new(   digit1 => $brokenDigits[0],
                                        digit2 => $brokenDigits[1],
                                        digit3 => $brokenDigits[2],
                                        digit4 => $brokenDigits[3],
                                        digit5 => $brokenDigits[4],
                                        digit6 => $brokenDigits[5],
                                        digit7 => $brokenDigits[6],
                                        digit8 => $brokenDigits[7],
                                        digit9 => $brokenDigits[8],
                                        digit10 => $brokenDigits[9],
                                        digit11 => $brokenDigits[10],
                                        digit12 => $brokenDigits[11]
                                    );

                                    #print Dumper \$brokenDisplay;
    my $brokenDisplayDigits = $brokenDisplay->getDigitsInArray();
    my $symbolsForShowCount = 0;
    my $brokenDisplayDigitsCount = 0;
    my $possible = 1;
#$DB::single = 2;
    while ( $symbolsForShowCount <= $#{$symbolsForShow} ){

        my $brokenDigit = $brokenDisplayDigits->[$brokenDisplayDigitsCount];
        my $digitForShow = $symbolsForShow->[$symbolsForShowCount];

        #If this part of display can show digit
        if ( $brokenDigit->avaiableValues( $digitForShow->{value} )){

            #if we need mark and broken display can show it or we don't need a mark
            if ( ($digitForShow->{mark} && $brokenDigit->segment8) || !$digitForShow->{mark} ){

                $symbolsForShowCount++;
                $brokenDisplayDigitsCount++;
            }else{
                $brokenDisplayDigitsCount++ if ( $symbolsForShowCount == 0 );
                $symbolsForShowCount = 0;
                $possible = 0 if ( (scalar @$brokenDisplayDigits - $brokenDisplayDigitsCount) < scalar @$symbolsForShow );
            }
        }else{
            $brokenDisplayDigitsCount++ if ( $symbolsForShowCount == 0 );
            $symbolsForShowCount = 0;
            $possible = 0 if ( (scalar @$brokenDisplayDigits - $brokenDisplayDigitsCount) < scalar @$symbolsForShow );
        }
    last unless ( $possible );
    }
    #print Dumper \@displaysWithDigits;
    return 1 if $possible;
    return 0;
} ## --- end sub calc

sub formSymbolsForShow {
    my	( $inpDigit )	= @_;

    my @symbols = split //,$inpDigit;
    my $digits = [];

    for ( my $i = 0; $i <= $#symbols; $i++ ) {

        if ( $symbols[$i] eq "." && scalar @$digits == 0){
            my $digit = {};
            $digit->{value} = 0;
            $digit->{mark} = 1;
#            push @$digits,$digit;
        }elsif( $symbols[$i] eq "." && scalar @$digits > 0){
            next;
        }else{
            my $digit = {};
            $digit->{value} = $symbols[$i];
            $digit->{mark} = 0;

            if ( $i < $#symbols && $symbols[$i+1] eq "."){
                $digit->{mark} = 1;
            }
            push @$digits,$digit;
        }
    }
    # print Dumper \$digits;
    return $digits;
} ## --- end sub formSymbolsForShow
