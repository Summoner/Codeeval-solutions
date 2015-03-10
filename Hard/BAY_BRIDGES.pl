#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper;
use Benchmark;

my $t0 = new Benchmark;

  open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
 #open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";

my $points = {};

	while(<$input>){
    	chomp;
	    my ($point_number,$point_coordinats) = ( split /:\s+/,$_ );
        my @coordinats = ( $point_coordinats =~/\(\[(-?\d+\.\d+),\s*(-?\d+\.\d+)\],?\s*\[(-?\d+\.\d+),\s*(-?\d+\.\d+)\]\)/g );
        $points->{$point_number}->{X1} = $coordinats[0];
        $points->{$point_number}->{Y1} = $coordinats[1];
        $points->{$point_number}->{X2} = $coordinats[2];
        $points->{$point_number}->{Y2} = $coordinats[3];

    }
close $input;


my $graph = {};
foreach my $key1 ( sort{ $a <=> $b } keys %$points ) {

    foreach my $key2 ( sort { $a<=>$b } keys %$points ) {

        next if ( $key1 == $key2 );
        if ( have_common_point( $points->{$key1},$points->{$key2} ) ){

            $graph->{$key1}->{$key2} = 1;
        }
    }
}

foreach my $key1 ( sort{ $a <=> $b } keys %$points ) {

    next if ( exists $graph->{ $key1 } );
    $graph->{$key1} = {};
}

#print Dumper \$graph;

form_arrays($graph);

sub form_arrays {
    my	( $graph )	= @_;

    my $arr1 = [];
    my $arr2 = [];

    @$arr1 = sort { $a <=> $b } keys %$graph;

    my $cash = {};
    foreach my $element ( @$arr1 ) {

        next if ( exists $cash->{$element} );
        if ( scalar keys %{ $graph->{$element} } > 0 ){

            my @links = sort { $a <=> $b } keys %{ $graph->{$element} };

            foreach my $linked_element ( @links ) {

                next if ( exists $cash->{$linked_element} );
                $cash->{$linked_element}++;
                push @$arr2,$linked_element;
            }
            $cash->{$element}++;
            push @$arr2,$element;
        }else{

            $cash->{$element}++;
            push @$arr2,$element;
        }
    }
    #print "arr1: ",join " ",@$arr1,"\n";
    #print "arr2: ",join " ",@$arr2,"\n";

    #my $arr = [10,22,9,33,21,50,41,60];
    longest_increasing_susequence( $arr2 );

} ## --- end sub form_arrays

sub longest_increasing_susequence {
    my	( $sequence )	= @_;

    my $subsequences = [];

    for ( my $i=0; $i <= $#{$sequence}; $i++ ) {

        my $last_element = $sequence->[$i];
        #First element of sequence
        if ( $i == 0 ){

            my $subsequence = [];
            push @{ $subsequence },$last_element;
            push @$subsequences,$subsequence;

        }else{

            #@$subsequences = sort { scalar @{$b} <=> scalar @{$a} }@$subsequences;

            foreach my $subsequence ( @$subsequences ) {

                if ( $last_element > $subsequence->[-1] ){

                    push @$subsequence,$last_element;
                    #last;
                }
            }
        }
    }
    @$subsequences = sort { scalar @{$b} <=> scalar @{$a} }@$subsequences;

    foreach my $element ( @{$subsequences->[0]} ){

        print "$element\n";
    }
    #  return $subsequences->[0];
} ## --- end sub longest_increasing_susequence

sub have_common_point {
    my	( $point1,$point2 )	= @_;

   my $a1 = $point1->{Y1} - $point1->{Y2};
   my $b1 = $point1->{X2} - $point1->{X1};
   my $d1 = $point1->{X1}*$point1->{Y2} - $point1->{X2} * $point1->{Y1};

   my $a2 = $point2->{Y1} - $point2->{Y2};
   my $b2 = $point2->{X2} - $point2->{X1};
   my $d2 = $point2->{X1}*$point2->{Y2} - $point2->{X2} * $point2->{Y1};

   my $seg1_line2_start = $a2 * $point1->{X1} + $b2 * $point1->{Y1} + $d2;
   my $seg1_line2_end = $a2 * $point1->{X2} + $b2 * $point1->{Y2} + $d2;

   my $seg2_line1_start = $a1 * $point2->{X1} + $b1 * $point2->{Y1} + $d1;
   my $seg2_line1_end = $a1 * $point2->{X2} + $b1 * $point2->{Y2} + $d1;

   return 0 if ( $seg1_line2_start * $seg1_line2_end >= 0 || $seg2_line1_start * $seg2_line1_end >= 0 );
   return 1;
} ## --- end sub have_common_point

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
