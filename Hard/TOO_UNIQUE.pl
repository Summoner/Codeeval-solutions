#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper;
use Benchmark;

my $t0 = new Benchmark;

  open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
 #open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";

my $matrix = [];

	while(<$input>){
    	chomp;
	    push @$matrix,[split //,$_];
	}
close $input;

solution( $matrix );

sub solution {
    my	( $matrix )	= @_;

    #find first submatrix max size of uniq elements
   my ( $maxCount,$finalLeft,$finalRight,$finalTop,$finalBottom ) =  findMaxSubMatrix( $matrix );

  
    my $count = 1;

    while ( $count > 0 ){

        #clear this elements from global matrix
        clear_matrix( $matrix,$finalLeft,$finalRight,$finalTop,$finalBottom );

        #show_matrix( $matrix );
        #print "****************************\n";
       ( $count,$finalLeft,$finalRight,$finalTop,$finalBottom ) = findMaxSubMatrix( $matrix,$maxCount );
       
    }
    show_matrix( $matrix );
} ## --- end sub solution



sub findMaxSubMatrix {
    my	( $matrix,$firstMaxCount )	= @_;

    my $finalRight = 0;
    my $finalLeft = 0;
    my $finalTop = 0;
    my $finalBottom = 0;

    my $left = 0;
    my $right = 0;
    my $top = 0;
    my $bottom = 0;
    my $temp = [];
    my $count = 0;
    my $maxCount = undef;

    
    for ( my $left = 0; $left < scalar @{$matrix->[0]}; $left++ ) {

        $temp = [];
        for ( my $right = $left; $right < scalar @{$matrix->[0]}; $right++ ) {

            for ( my $i=0; $i < scalar @{$matrix}; $i++ ) {

                $temp->[$i]->[$right] = $matrix->[$i]->[$right];
            }

            ( $count,$top,$bottom ) = arr_part( $temp,$left,$right );
            if ( !defined $maxCount || $maxCount < $count ){

                $maxCount = $count;
                $finalLeft = $left;
                $finalRight = $right;
                $finalTop = $top;
                $finalBottom = $bottom;
            }
        }
    }

    unless ( defined $firstMaxCount ){

        return ( $maxCount,$finalLeft,$finalRight,$finalTop,$finalBottom );

    }else{
    
        if ( $firstMaxCount == $maxCount ){
        
            return ( $maxCount,$finalLeft,$finalRight,$finalTop,$finalBottom ); 

        }else{
        
            return (0);
        }
    }
    #print "leftborder: $finalLeft\n";
    #print "rightborder: $finalRight\n";
    #print "topborder: $finalTop\n";
    #print "bottomborder: $finalBottom\n";
} ## --- end sub findMaxSumm

sub arr_part {
    my	( $arr,$left,$right )	= @_;

    my $maxElementsCount = undef;
    my $finalLeft = 0;
    my $finalRight = 0;
    my $finalTop = 0;
    my $finalBottom = 0;

        for ( my $up = 0; $up < scalar @{$arr}; $up++ ) {

            my $temp = [];
            for ( my $bottom = $up; $bottom < scalar @{$arr}; $bottom++ ) {

                $temp->[$bottom] = $arr->[$bottom];
                my $elements_count = check( $temp );
                if ( !defined $maxElementsCount || $maxElementsCount < $elements_count ){

                    $maxElementsCount = $elements_count;
                    $finalLeft = $left;
                    $finalRight = $right;
                    $finalTop = $up;
                    $finalBottom = $bottom;
                }
            }
        }

        return ( $maxElementsCount,$finalTop,$finalBottom );
} ## --- end sub arr_part

sub check {
    my	( $arr )	= @_;

    #   print "left: $left,right: $right,up: $up, bottom: $bottom************************************************\n";
    #   print Dumper \$arr;
    #   print "************************************************\n";

    my %duplicates = ();
    foreach my $a ( @$arr ) {

        next unless defined $a;

        foreach my $element ( @$a ) {

            next unless defined ( $element );
            $duplicates{$element}++
        }
    }
    my $elements_count = 0;
    foreach my $value ( values %duplicates ) {

        if ( $value > 1 ){

            return $elements_count;
        }
    }
    $elements_count = scalar keys %duplicates;
    return  $elements_count;
} ## --- end sub check

sub clear_matrix {
    my	( $matrix,$finalLeft,$finalRight,$finalTop,$finalBottom )	= @_;

    for ( my $j = $finalLeft; $j <= $finalRight; $j++ ) {

        for ( my $i = $finalTop; $i <= $finalBottom; $i++ ) {

            $matrix->[$i]->[$j] = "*";
        }
    }    
} ## --- end sub clear_matrix

sub show_matrix {
    my	( $matrix )	= @_;

    foreach my $arr ( @$matrix ) {

        print join "",@$arr,"\n";
    }    
} ## --- end sub show_matrix


my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
