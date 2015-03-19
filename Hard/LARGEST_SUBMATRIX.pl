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
	    push @$matrix,[split /\s+/,$_];
	}
close $input;

findMaxSubMatrix( $matrix );

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
    my $summ = 0;
    my $maxSumm = undef;

    #Initialize temp
    for ( my $i = 0; $i < scalar @{$matrix}; $i++ ) {

        $temp->[$i] = 0;
    }

    for ( my $left = 0; $left < scalar @{$matrix->[0]}; $left++ ) {

        $temp = [];
        for ( my $right = $left; $right < scalar @{$matrix->[0]}; $right++ ) {

            for ( my $i=0; $i < scalar @{$matrix}; $i++ ) {

                $temp->[$i] += $matrix->[$i]->[$right];
            }

            ( $summ,$top,$bottom ) = calc( $temp );
            if ( !defined $maxSumm || $maxSumm <  $summ ){

                $maxSumm = $summ;
                $finalLeft = $left;
                $finalRight = $right;
                $finalTop = $top;
                $finalBottom = $bottom;
            }
        }
    }
    #print "Left: $finalLeft\n";
    #print "Right: $finalRight\n";
    #print "Top: $finalTop\n";
    #print "Bottom: $finalBottom\n";
    print $maxSumm,"\n";

}


sub calc {
        my	( $arr )	= @_;

        my $summ = 0;
        my $start = 0;
        my $local_start = 0;
        my $finish = -1;
        my $maxSumm = undef;

        for ( my $i = 0; $i < scalar @$arr; $i++ ) {

            $summ += $arr->[$i];
            if ( $summ < 0 ){

                $local_start = $i+1;
                $summ = 0;

            }elsif ( !defined $maxSumm || $maxSumm < $summ ){

                $maxSumm = $summ;
                $start = $local_start;
                $finish = $i;
            }
        }
        return ( $maxSumm,$start,$finish ) unless ( $finish == -1 );

        $maxSumm = $arr->[0];
        $start = 0;
        $finish = 0;

        for ( my $i = 0; $i < scalar @{$arr}; $i++ ) {

            if ( $maxSumm < $arr->[$i] ){

                $maxSumm = $arr->[$i];
                $start = $i;
                $finish = $i;
            }
        }
        return ( $maxSumm,$start,$finish );

} ## --- end sub calc


my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
