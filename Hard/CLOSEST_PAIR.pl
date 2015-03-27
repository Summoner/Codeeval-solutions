#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper;
use Benchmark;

my $t0 = new Benchmark;

open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
 #open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";

my $count = 0;
my $coord = [];

	while(<$input>){
    	chomp;
	    if ( $count == 0 ){

            if ( $_ == 0 ){

                solution( $coord );
                $coord = [];

            }else{

                $count = $_;
            }

        }else{

            push @$coord, [split /\s+/,$_];
            $count--;
        }
	}
close $input;

sub solution {
    my	( $coord )	= @_;

    my @points = ();
    foreach my $pair ( @$coord ) {

        my $point = {};

        $point->{x} = $pair->[0];
        $point->{y} = $pair->[1];
        push @points,$point;
    }

    print Closest(\@points),"\n";
}

sub Closest {
    my	( $points )	= @_;

    my $pointsX = [];
    my $pointsY = [];

    for ( my $i=0;$i < scalar @$points; $i++ ) {

        $pointsX->[$i] = $points->[$i];
        $pointsY->[$i] = $points->[$i];
    }

    sort_x( $pointsX );
    sort_y( $pointsY );
    #$DB::single = 2;
    my $result = ClosestUtil( $pointsX,$pointsY,scalar @$points );

    if ( $result >= 10000 ){

        return "INFINITY";

    }else{

        return sprintf( "%.4f",$result);
    }

} ## --- end sub Closest

sub ClosestUtil {
    my	( $Px,$Py,$n )	= @_;

    if ( $n <= 3 ){

        return brute_force( $Px );
    }

    my $mid = int ( $n / 2);
    my $midPoint = $Px->[$mid];

    my $Pyl = [];
    my $Pyr = [];

    my $li = 0;
    my $ri = 0;

    for ( my $i=0; $i < $n; $i++ ) {

        if ( $Py->[$i]->{x} <= $midPoint->{x} ){

            $Pyl->[$li++] = $Py->[$i];

        }else{

            $Pyr->[$ri++] = $Py->[$i];
        }
    }
    my $dl = ClosestUtil( $Px, $Pyl, $mid);
    my $dr = ClosestUtil( $Px, $Pyr, $n - $mid);

    my $d = min( $dl,$dr );

    my $strip = [];
    my $j = 0;


    for ( my $i=0;$i < $n; $i++ ) {

        if ( abs( $Py->[$i]->{x} - $midPoint->{x}) < $d ){

            $strip->[$j] = $Py->[$i];
            $j++;
        }
    }

    return min( $d, stripClosest( $strip, $j,$d) );
} ## --- end sub ClosestUtil

sub stripClosest {
    my	( $strip, $size, $d )	= @_;

    my $min = $d;

    for ( my $i=0; $i < $size; $i++  ) {

        for ( my $j= $i+1;$j < $size && ( $strip->[$j]->{y} - $strip->[$i]->{y} ) < $min; $j++ ) {

            my $distance = dist( $strip->[$i],$strip->[$j]);
            if ( $distance < $min ){

                $min = $distance;
            }
        }
    }

return $min;
} ## --- end sub stripClosest

sub min {
    my	( $x,$y )	= @_;

    return $x if ( $x < $y );
    return $y;
} ## --- end sub min

sub brute_force {
    my	( $points )	= @_;
    my $min = undef;

    for ( my $i=0; $i < scalar @$points; $i++ ) {

        for ( my $j=$i+1; $j < scalar @$points; $j++ ) {

            my $distance = dist( $points->[$i],$points->[$j]);
            if ( !defined $min || $distance < $min ){

                $min = $distance;
            }
        }
    }
    return $min;
} ## --- end sub brute_force

sub dist {
    my	( $p1,$p2 )	= @_;

    return sqrt( ($p1->{x} - $p2->{x}) * ($p1->{x} - $p2->{x}) + ($p1->{y} - $p2->{y}) * ($p1->{y} - $p2->{y}) );
} ## --- end sub dist

sub sort_x {
    my	( $points )	= @_;

    @$points = sort { $a->{x} <=> $b->{x} } @$points;

} ## --- end sub sort_x

sub sort_y {
    my	( $points )	= @_;

    @$points = sort { $a->{y} <=> $b->{y} } @$points;

} ## --- end sub sort_x


my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
