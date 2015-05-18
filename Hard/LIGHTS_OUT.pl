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
	    push @list,[split /\s+/,$_];
	}
close $input;

#print Dumper \@list;

foreach my $arr ( @list ) {

   print convert( $arr ),"\n";
}

sub convert {
    my	( $arr )	= @_;
    my $M = $arr->[0];
    my $N = $arr->[1];
    my @symbolsStrings = split /\|/,$arr->[2];
    my @symbols = ();
    foreach my $symbolsString ( @symbolsStrings ) {

        push @symbols,[split //,$symbolsString];
    }

    my $matrix = [];

    for ( my $i = 0; $i < $M; $i++ ) {

        my $row = [];
        for ( my $j = 0; $j < $N; $j++ ) {

            my $symbol = $symbols[$i]->[$j];
            if ($symbol eq "O"){

                push @$row, 1;

            }elsif( $symbol eq "."){

                push @$row,0;
            }
        }
        push @$matrix,$row;
    }
    #$DB::single = 2;
    return answer( $matrix,$M,$N );
} ## --- end sub convert

sub answer {
    my	( $matrix,$M,$N )	= @_;
    my $toggle = makeToggleMatrix( $N );
    my $puzzle = linearizePuzzle( $matrix );

    my $solution = solvePuzzle( $toggle,$puzzle );
    return -1 if ( $solution == -1 );

    my %countOnes = ();

    foreach my $digit ( @$solution ) {

        $countOnes{$digit}++;
    }
    return $countOnes{1};
} ## --- end sub answer

sub solvePuzzle {
    my	( $toggle,$puzzle )	= @_;

    ( $toggle,$puzzle ) = performGaussianElimination( $toggle,$puzzle );
    return backSubstitute( $toggle,$puzzle );
} ## --- end sub solvePuzzle

sub performGaussianElimination {
    my	( $toggle,$puzzle )	= @_;

    my $nextFreeRow = 0;

    for ( my $col = 0; $col <= $#{$toggle->[0]}; $col++ ) {

        my $pivotRow = findPivot( $toggle,$nextFreeRow,$col );
        next if ( $pivotRow == -1 );
        swapRanges( $toggle,$pivotRow,$nextFreeRow );
        swapRanges( $puzzle,$pivotRow,$nextFreeRow );

        for ( my $row = $pivotRow + 1; $row <= $#{$puzzle}; $row++ ) {

            if ( $toggle->[$row]->[$col] ){

                for ( my $k = 0; $k <= $#{$toggle->[$row]}; $k++ ) {

                    $toggle->[$row]->[$k] ^= $toggle->[$nextFreeRow]->[$k];
                }
                $puzzle->[$row] ^= $puzzle->[$nextFreeRow];
            }
        }
    }
    return ($toggle,$puzzle);
} ## --- end sub performGaussianElimination

sub backSubstitute {
    my	( $toggle,$puzzle )	= @_;

    my $result = [];

    foreach ( @$puzzle ) {

        push @$result,0;
    }
    my $pivot = -1;
#$DB::single = 1;
    for ( my $row = $#{$puzzle}; $row >= 0; $row-- ) {

        for ( my $col=0; $col <= $#{$puzzle}; $col++ ) {

            if ( $toggle->[$row]->[$col] ){

                $pivot = $col;
                last;
            }
        }
        if ( $pivot == -1 ){

            if ( $puzzle->[$row] ){

                return -1;
            }
        }else{

            $result->[$row] = $puzzle->[$row];

            for ( my $col = $pivot+1; $col <= $#{$puzzle}; $col++ ) {

                if ( $result->[$row] != ( $toggle->[$row]->[$col] && $result->[$col] ) ){

                    $result->[$row] = 1;
                }else{

                    $result->[$row] = 0;
                }
            }
        }
    }
    return $result;
} ## --- end sub backSubstitute

sub findPivot {
    my	( $matrix,$startRow,$pivotColumn )	= @_;

    for ( my $i= $startRow; $i <= $#{$matrix}; $i++ ) {

        if ( $matrix->[$i]->[$pivotColumn] ){

            return $i;
        }
    }
    return -1;
} ## --- end sub findPivot

sub linearizePuzzle {
    my	( $puzzle,$M,$N )	= @_;
    my $linearized = [];

    for ( my $i = 0; $i <= $#{$puzzle}; $i++ ) {

        for ( my $j = 0; $j <= $#{$puzzle->[$i]}; $j++ ) {

            push @$linearized,$puzzle->[$i]->[$j];
        }
    }
    return $linearized;
} ## --- end sub linearizePuzzle

sub makeToggleMatrix {
    my	( $N )	= @_;
    my $result = [];

    for ( my $i = 0; $i < $N * $N; $i++ ) {

        for ( my $j = 0; $j < $N * $N; $j++ ) {

            $result->[$i]->[$j] = 0;
        }
    }

    for ( my $i = 0; $i < $N; $i++ ) {

        for ( my $j = 0; $j < $N; $j++ ) {

            my $column = rowMajorIndex( $i,$j,$N );
            $result->[$column]->[ $column ] = 1;

            for ( my $k = 0; $k < $N; $k++ ) {

                $result->[$column]->[ $N * $i + $k ] = 1;
                $result->[$column]->[ $N * $k + $j ] = 1;

            }
        }
    }
    #$DB::single = 2;
    return $result;
} ## --- end sub makeToggleMatrix

sub rowMajorIndex {
    my	( $i,$j,$N )	= @_;

    return $i * $N + $j;
    return ;
} ## --- end sub rowMajorIndex

sub swapRanges {
    my	( $arr,$row1,$row2 )	= @_;

    my $temp1 = $arr->[$row1];
    my $temp2 = $arr->[$row2];

    $arr->[$row1] = $temp2;
    $arr->[$row2] = $temp1;

    return $arr;
} ## --- end sub swapRanges

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
