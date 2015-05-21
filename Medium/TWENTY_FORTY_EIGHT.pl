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
	    push @list,[split /;\s+/,$_];
	}
close $input;

#print Dumper \@list;

foreach my $arr ( @list ) {

    calc( $arr );
}

sub calc {
    my ( $par )	= @_;

    my $direction = $par->[0];
    my $matrix = createMatrix($par->[2]);

    #print "*************************\n";
    #showMatrix($matrix);
    proceed( $direction,$matrix);
    #print "-------------------------\n";
    #showMatrix($matrix);
    #print "*************************\n";

    for ( my $i = 0; $i <= $#{$matrix}; $i++ ) {

        print join(" ",@{$matrix->[$i]} );
        last if ( $i == $#{$matrix});
        print "|";
    }
    print "\n";
} ## --- end sub calc

sub proceed {
    my	( $direction,$matrix )	= @_;
#    $DB::single = 2;
    if ($direction eq "RIGHT"){

        for ( my $i = 0; $i <= $#{$matrix}; $i++ ) {

            updateRight( $matrix,$i );
        }

    }elsif ($direction eq "LEFT"){

        for ( my $i = 0; $i <= $#{$matrix}; $i++ ) {

            updateLeft( $matrix,$i );
        }
    }elsif ($direction eq "UP"){

        for ( my $j = 0; $j <= $#{$matrix->[0]}; $j++ ) {

            updateUp( $matrix,$j );
        }
    }elsif ($direction eq "DOWN"){

        for ( my $j = 0; $j <= $#{$matrix->[0]}; $j++ ) {

            updateDown( $matrix,$j );
        }
    }
}## --- end sub proceed

sub updateRight {
    my	( $matrix,$i )	= @_;

    #Shift to the right
    shiftRight($matrix->[$i]);
    #Remove duplicates
    duplicatesRight( $matrix->[$i] );
    #Shift to the right
    shiftRight($matrix->[$i]);
} ## --- end sub update

sub shiftRight {
    my	( $arr )	= @_;

    for ( my $j = $#{$arr}-1; $j >= 0; $j-- ) {

        next if ( $arr->[$j] == 0 );

        if ( $arr->[$j+1] == 0 ){

            my $k = $j;
            while ( $k < $#{$arr} && $arr->[$k+1] == 0 ){

                $arr->[$k+1] = $arr->[$k];
                $arr->[$k] = 0;
                $k++;
            }
        }
    }
} ## --- end sub shiftRight

sub duplicatesRight {
    my	( $arr )	= @_;

    for ( my $j = $#{$arr}; $j > 0; $j-- ) {

        next if ( $arr->[$j] == 0 );
        if ( $arr->[$j-1] == $arr->[$j] ){

            $arr->[$j] += $arr->[$j-1];
            $arr->[$j-1] = 0;
        }
    }
} ## --- end sub duplicatesRight

sub updateLeft {
    my	( $matrix,$i )	= @_;

    #Shift to the left
    shiftLeft($matrix->[$i]);
    #Remove duplicates
    duplicatesLeft( $matrix->[$i] );
    #Shift to the left
    shiftLeft($matrix->[$i]);
} ## --- end sub update

sub shiftLeft {
    my	( $arr )	= @_;

    for ( my $j = 1; $j <= $#{$arr}; $j++ ) {

        next if ( $arr->[$j] == 0 );

        if ( $arr->[$j-1] == 0 ){

            my $k = $j;
            while ( $k > 0 && $arr->[$k-1] == 0 ){

                $arr->[$k-1] = $arr->[$k];
                $arr->[$k] = 0;
                $k--;
            }
        }
    }
} ## --- end sub shiftLeft

sub duplicatesLeft {
    my	( $arr )	= @_;

    for ( my $j = 0; $j < $#{$arr}; $j++ ) {

        next if ( $arr->[$j] == 0 );
        if ( $arr->[$j+1] == $arr->[$j] ){

            $arr->[$j] += $arr->[$j+1];
            $arr->[$j+1] = 0;
        }
    }
} ## --- end sub duplicatesLeft


sub updateUp {
    my	( $matrix,$j )	= @_;

    #Shift to the up
    shiftUp( $matrix,$j );
    #Remove duplicates
    duplicatesUp( $matrix,$j );
    #Shift to the Up
    shiftUp( $matrix,$j );
} ## --- end sub update

sub shiftUp {
    my	( $matrix,$j )	= @_;

    for ( my $i = 1; $i <= $#{$matrix}; $i++ ) {

        next if ( $matrix->[$i]->[$j] == 0 );

        if ( $matrix->[$i-1]->[$j] == 0 ){

            my $k = $i;
            while ( $k > 0 && $matrix->[$k-1]->[$j] == 0 ){

                $matrix->[$k-1]->[$j] = $matrix->[$k]->[$j];
                $matrix->[$k]->[$j] = 0;
                $k--;
            }
        }
    }
} ## --- end sub shiftUp

sub duplicatesUp {
    my	( $matrix,$j )	= @_;

    for ( my $i = 0; $i < $#{$matrix}; $i++ ) {

        next if ( $matrix->[$i]->[$j] == 0 );
        if ( $matrix->[$i+1]->[$j] == $matrix->[$i]->[$j] ){

            $matrix->[$i]->[$j] += $matrix->[$i+1]->[$j];
            $matrix->[$i+1]->[$j] = 0;
        }
    }
} ## --- end sub duplicatesUp

sub updateDown {
    my	( $matrix,$j )	= @_;

    #Shift to the down
    shiftDown( $matrix,$j );
    #Remove duplicates
    duplicatesDown( $matrix,$j );
    #Shift to the down
    shiftDown( $matrix,$j );
} ## --- end sub update

sub shiftDown {
    my	( $matrix,$j )	= @_;

    for ( my $i = $#{$matrix}-1; $i >= 0; $i-- ) {

        next if ( $matrix->[$i]->[$j] == 0 );

        if ( $matrix->[$i+1]->[$j] == 0 ){

            my $k = $i;
            while ( $k < $#{$matrix} && $matrix->[$k+1]->[$j] == 0 ){

                $matrix->[$k+1]->[$j] = $matrix->[$k]->[$j];
                $matrix->[$k]->[$j] = 0;
                $k++;
            }
        }
    }
} ## --- end sub shiftDown

sub duplicatesDown {
    my	( $matrix,$j )	= @_;

    for ( my $i = $#{$matrix}; $i > 0; $i-- ) {

        next if ( $matrix->[$i]->[$j] == 0 );
        if ( $matrix->[$i-1]->[$j] == $matrix->[$i]->[$j] ){

            $matrix->[$i]->[$j] += $matrix->[$i-1]->[$j];
            $matrix->[$i-1]->[$j] = 0;
        }
    }
} ## --- end sub duplicatesDown

sub createMatrix {
    my	( $str )	= @_;

    my @parts = split /\|/,$str;
    my $matrix = [];
    foreach my $part ( @parts ) {

        my @elements = split /\s+/,$part;
        push @$matrix,\@elements;
    }
    return $matrix;
} ## --- end sub createMatrix


sub showMatrix {
    my	( $matrix )	= @_;


    for ( my $i = 0; $i <= $#{$matrix}; $i++ ) {

        for ( my $j = 0; $j <= $#{$matrix->[$i]}; $j++ ) {

            print "$matrix->[$i]->[$j]\t";
        }
        print "\n";
    }
} ## --- end sub showMatrix



my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
