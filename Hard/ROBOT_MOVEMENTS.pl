#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper;
use Benchmark;

my $t0 = new Benchmark;

my $grid_size = 4;
my $grid = [];

create_grid( $grid );

my $paths_count = deep( $grid,0,0,$grid_size);
print "$paths_count\n";

sub deep {
    my	( $grid,$i,$j,$size )	= @_;

    return 0 if ( $i <0 || $j < 0 || $i >= $size || $j >= $size );
    return 0 if ( $grid->[$i]->[$j] == 1 );
    return 1 if ( ($i == $size-1) && ($j == $size-1) );

    $grid->[$i]->[$j] = 1;
    my $count = 0;
    $count += deep( $grid,$i+1,$j,$size );
    $count += deep( $grid,$i-1,$j,$size );
    $count += deep( $grid,$i,$j-1,$size );
    $count += deep( $grid,$i,$j+1,$size );
    $grid->[$i]->[$j] = 0;

    return $count;
} ## --- end sub deep

sub create_grid {
    my	( $grid )	= @_;

    for ( my $i=0; $i < $grid_size; $i++ ) {

        for ( my $j = 0; $j < $grid_size; $j++ ) {

            $grid->[$i]->[$j] = 0;
        }
    }
} ## --- end sub create_grid

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
