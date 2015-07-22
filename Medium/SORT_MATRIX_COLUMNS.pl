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
	    push @list,[split /\s+/,$_];
	}
close $input;

foreach my $symbolsArr ( @list ){

    my $matrix = [];
    createMatrix( $matrix,$symbolsArr );
    $matrix = pivotMatrix( $matrix );
    my $sortStr = createSortString( $matrix );
    my @sortedMatrix = eval( $sortStr );
    $matrix = reversePivotMatrix( \@sortedMatrix );
    showMatrix( $matrix );
    # print Dumper \$matrix;
}

sub createMatrix {
    my	( $matrix,$symbolsArr ) = @_;
    my $row = 0;
    my $column = 0;

    foreach my $symbol ( @$symbolsArr ) {
        if ( $symbol eq '|' ){
            $row++;
            $column = 0;
        }else{
            $matrix->[$row]->[$column] = $symbol;
            $column++;
        }
    }
    #   print Dumper \$matrix;
} ## --- end sub createMatrix

sub showMatrix {
    my	( $matrix )	= @_;

    print join ( " | ", map { join " ",@$_ } @$matrix ),"\n";
} ## --- end sub showMatrix

sub createSortString {
    my	( $matrix )	= @_;
    my $str = '';
    my $strFirstPart =  ' sort{ ';

    $str .= $strFirstPart;

    for ( my $col = 0; $col <= $#{$matrix->[0]}; $col++ ) {
        my $strPart = '$a->['."$col".'] <=> $b->['."$col".'] ';
        $str .= $strPart;
        last if ( $col == $#{$matrix->[0]} );
        my $orStr = ' || ';
        $str .= $orStr;
    }
    my $strLastPart = '}@$matrix;';
    $str .= $strLastPart;
    return $str;
} ## --- end sub createSortString

sub reversePivotMatrix {
    my	( $pivotedMatrix )	= @_;
    my $matrix = [];

    for ( my $row = 0; $row <= $#{$pivotedMatrix}; $row++ ) {
        for ( my $col = 0; $col <= $#{$pivotedMatrix->[$row]}; $col++ ) {
            $matrix->[$col]->[$row] = $pivotedMatrix->[$row]->[$col];
        }
    }
    return $matrix;
} ## --- end sub pivotMatrix

sub pivotMatrix {
    my	( $matrix )	= @_;
    my $pivotedMatrix = [];

    for ( my $row = 0; $row <= $#{$matrix}; $row++ ) {
        for ( my $col = 0; $col <= $#{$matrix->[$row]}; $col++ ) {
            $pivotedMatrix->[$col]->[$row] = $matrix->[$row]->[$col];
        }
    }
    return $pivotedMatrix;
} ## --- end sub pivotMatrix

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
