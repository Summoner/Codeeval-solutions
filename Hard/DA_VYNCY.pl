#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper;
use Benchmark;

my $t0 = new Benchmark;

 open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
# open my $result, ">/home/fanatic/Summoner/Codeeval-solutions/output.txt" || die "Can't open file: $!\n";

my @list = ();

	while(<$input>){
    	chomp;
	    push @list,[split /;/,$_];
	}
close $input;
my $prefixesCash = {};
foreach my $words ( @list ) {

#    my $text = "ABCDABDCABD";
#    my $str = "ABD";
#    my ( $overlappingValue, $overlappedString ) = OverlappingStringsModification( $text,$str );
#    print "overlapping value: $overlappingValue\n";
#    print "overlapping string: $overlappedString\n";
#    print "#####################################################\n";
#    ( $text,$str ) = ( $str,$text );
#    ( $overlappingValue, $overlappedString ) = OverlappingStringsModification( $text,$str );
#    print "overlapping value: $overlappingValue\n";
#    print "overlapped string: $overlappedString\n";
    $prefixesCash = {};
    calc( $words );
}

sub calc {
    my	( $words )	= @_;
    my $overlappedStr = undef;
    my $overlappingPossible = 1;
    my $indexOfTextOverlapped = 0;
    my $indexOfStringOverlapped = 0;
    my $overlappingMaxValue = 0;

    #Cash structure:
    #cash->{index Of Text For Overlapp }->{ Index of string for overlapp }-> { overlapped value }
    #cash->{index Of Text For Overlapp }->{ Index of string for overlapp }-> { overlapped string }
    my $cash = {};

    while ( $overlappingPossible ){

        ( $overlappingMaxValue, $indexOfTextOverlapped,$indexOfStringOverlapped, $overlappedStr ) = FindMaxOverlapping( $words,$cash );

        if( $overlappingMaxValue > 0 ){
            $words->[ $indexOfTextOverlapped ] = $overlappedStr;
            $words->[ $indexOfStringOverlapped ] = undef;
            ClearCash( $cash,$indexOfTextOverlapped );
#            ClearCash( $cash,$indexOfStringOverlapped );
            #delete $cash->{ $indexOfTextOverlapped }->{ $indexOfStringOverlapped };
        }else{
            $overlappingPossible = 0;
        }
    }
   print $words->[0],"\n";
} ## --- end sub calc

sub FindMaxOverlapping {
    my	( $words,$cash )	= @_;

    my $overlappedMaxValue = 0;
    my $overlappedStr = undef;

    my $overlappingValue = 0;
    my $overlappingString = undef;

    my $indexOfTextOverlapped = 0;
    my $indexOfStringOverlapped = 0;

    for ( my $i = 0; $i < $#{$words}; $i++ ) {
        next unless ( defined $words->[$i] );

        for ( my $j = $i+1; $j <= $#{$words}; $j++ ) {
            next unless ( defined $words->[$j] );

            ( $overlappingValue, $overlappingString ) = CheckOverlapping( $i,$j,$words,$cash );

            if ( $overlappingValue > $overlappedMaxValue ){
                $overlappedMaxValue = $overlappingValue;
                $overlappedStr = $overlappingString;
                $indexOfTextOverlapped = $i;
                $indexOfStringOverlapped = $j;
            }
        }
    }
    return ( $overlappedMaxValue, $indexOfTextOverlapped, $indexOfStringOverlapped, $overlappedStr );
} ## --- end sub FindMaxOverlapping

sub CheckOverlapping {
    my	( $textIndex,$wordIndex,$words,$cash )	= @_;

            my $text = $words->[ $textIndex ];
            my $word = $words->[ $wordIndex ];
            my $overlappingValue = 0;
            my $overlappingMaxValue = 0;
            my $overlappingString = undef;
            my $overlappedString = undef;

            unless ( exists $cash->{ $textIndex }->{ $wordIndex } ){

                ( $overlappingValue,$overlappingString ) = OverlappingStringsModification( $text,$word );

                if ( $overlappingValue > $overlappingMaxValue ){
                    $overlappingMaxValue = $overlappingValue;
                    $overlappedString = $overlappingString;
                    $cash->{ $textIndex }->{ $wordIndex }->{ overlappingValue } = $overlappingValue;
                    $cash->{ $textIndex }->{ $wordIndex }->{ overlappingString } = $overlappingString;
                }else{
                    $cash->{ $textIndex }->{ $wordIndex }->{ overlappingValue } = $overlappingMaxValue;
                    $cash->{ $textIndex }->{ $wordIndex }->{ overlappingString } = $overlappedString;
                }
                    ( $word, $text ) = ( $text,$word );
                    ( $overlappingValue,$overlappingString ) = OverlappingStringsModification( $text,$word );

                if ( $overlappingValue > $overlappingMaxValue ){
                    $overlappingMaxValue = $overlappingValue;
                    $overlappedString = $overlappingString;
                    $cash->{ $textIndex }->{ $wordIndex }->{ overlappingValue } = $overlappingValue;
                    $cash->{ $textIndex }->{ $wordIndex }->{ overlappingString } = $overlappingString;
                }
            }else{
                $overlappingMaxValue = $cash->{ $textIndex }->{ $wordIndex }->{ overlappingValue };
                $overlappedString = $cash->{ $textIndex }->{ $wordIndex }->{ overlappingString };
            }
    return ( $overlappingMaxValue, $overlappedString );
} ## --- end sub CheckOverlapping

sub ClearCash {
    my	( $cash, $keyForClear )	= @_;

    delete $cash->{ $keyForClear };
    foreach my $key1 ( keys %$cash ) {
        foreach my $key2 ( keys %{ $cash->{ $key1 } } ) {
            delete $cash->{ $key1 }->{ $key2 } if ( $key2 == $keyForClear );
        }
    }
} ## --- end sub ClearCash

sub OverlappingStringsModification {
    my	( $T,$W )	= @_;
    # T - text to be searched
    # W - word sought
    my @textCharacters = split //,$T;
    my @wordCharacters = split //,$W;
    my $textIndex = 0;
    my $wordIndex = 0;
    my $startIndex = 0;
    my $overlappingValue = 0;
    my $overlappedString = undef;
    my $prefixesTable = [];

    unless ( defined $prefixesCash->{ $W } ){
        $prefixesTable = PrefixesTableBuilding( \@wordCharacters );
        $prefixesCash->{$W} = $prefixesTable;
    }else{
        $prefixesTable = $prefixesCash->{ $W };    
    }

    while( $textIndex <= $#textCharacters ){
        if ( $textCharacters[ $textIndex ] eq $wordCharacters[ $wordIndex ] ){

            my $lastTextCharacter = $textIndex == $#textCharacters ? 1:0;
            my $lastWordCharacter = $wordIndex == $#wordCharacters ? 1:0;

            if ( $lastWordCharacter ){
                #Overlapping at the beginning or at the end of the text and merging All word
                if ( $startIndex == 0 || $lastTextCharacter ){
                    $overlappingValue = scalar @wordCharacters;
                    #$overlappedString = join "",@textCharacters;
                    $overlappedString = $T;
                    return ( $overlappingValue, $overlappedString );
                }
            #Overlapping at the end of the text string and merging part of the word
            }elsif ( $lastTextCharacter ){
                $overlappingValue = scalar @textCharacters - $startIndex;
                splice ( @wordCharacters,0,$overlappingValue );
                push @textCharacters,@wordCharacters;
                $overlappedString = join "",@textCharacters;
                return ( $overlappingValue, $overlappedString );
            }
            $textIndex++;
            #If Overlapping in the middle of the text - need to proceed checking from beginning of word symbols
            if ( $lastWordCharacter ){
                $wordIndex = 0;
                $overlappingValue = scalar @wordCharacters;
                #$overlappedString = join "",@textCharacters;
                $overlappedString = $T;
            }else{
                $wordIndex++;
            }
        }else{
            if ( $wordIndex > 0 ){
                $wordIndex = $prefixesTable->[ $wordIndex - 1 ];
            }else{
                $textIndex++;
            }
            $startIndex = $textIndex - $wordIndex;
        }
    }
    return ( $overlappingValue,$overlappedString );
} ## --- end sub OverlappingStrings

## Overlapping strings algo realisation ##############################################################
sub OverlappingStrings {
    my	( $S,$W )	= @_;
    # S - text to be searched
    # W - word sought
    my @textCharacters = split //,$S;
    my @wordCharacters = split //,$W;
    my $textIndex = 0;
    my $wordIndex = 0;
    my $startIndex = 0;
    my $prefixesTable = PrefixesTableBuilding( \@wordCharacters );

    while( $textIndex <= $#textCharacters ){

        if ( $textCharacters[ $textIndex ] eq $wordCharacters[ $wordIndex ] ){
            return $startIndex if ( $wordIndex == $#wordCharacters );
            $textIndex++;
            $wordIndex++;
        }else{
            if ( $wordIndex > 0 ){
                $wordIndex = $prefixesTable->[ $wordIndex - 1 ];
            }else{
                $textIndex++;
            }
            $startIndex = $textIndex - $wordIndex;
        }
    }
    #We must something return here, if none symbols are overlap
    return scalar @textCharacters;
} ## --- end sub OverlappingStrings

sub PrefixesTableBuilding {
    my	( $word )	= @_;
    my $i = 1;
    my $j = 0;

    my $table = [];
    $table->[0] = 0;

    while ( $i <= $#{$word} ){

        if ( $word->[$i] eq $word->[$j] ){
            $table->[$i] = $j + 1;
            $i++;
            $j++;
        }else{
            if ( $j > 0 ){
                $j = $table->[$j-1];
            }else{
                $j = 0;
                $table->[$i] = 0;
                $i++;
            }
        }
    }
#    print join " ",@$table,"\n";
    return $table;
} ## --- end sub tableBuilding

######################################################################################################

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "All the code took:",timestr($td),"\n";
