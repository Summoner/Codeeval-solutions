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
	    push @list,[split /;/, $_];
	}
close $input;


foreach my $arr ( @list ) {

    my $levels = $arr->[0];
    my $labirinth_size = $levels;
    my @matrix = split //,$arr->[1];
    my $maze = [];

    create_maze( $labirinth_size,\@matrix,$maze );
    #show_maze( $maze );
    find_path( $maze,$labirinth_size );
    #print "$steps\n";
}

sub find_path {
    my	( $maze, $size )	= @_;
    # $DB::single = 2;

    my $input_point = find_point( $maze->[0] );
       $input_point->{level} = 0;

    my $output_point = find_point( $maze->[$size-1] );
       $output_point->{level} = $size - 1; 


    print Dumper \$input_point;
    print "******************\n";
    print Dumper \$output_point;
    print "******************\n";
    my $graph = create_graph( $maze );
    print Dumper \$graph;

    my $distances = shortest_path_dijkstra( $input_point,$graph );

    print Dumper \$distances;

} ## --- end sub find_path


sub shortest_path_dijkstra {
    my	( $start_point,$graph )	= @_;

    my $start = join ".",($start_point->{level},$start_point->{i},$start_point->{j});

    my %intree = ();
    my %distance = ();

    my $v = $start;
    my $dist = undef;
    my $w;
    my $weight;
    $distance{$v} = 0;

    while ( !exists $intree{$v} ){

        $intree{$v} = 1;

        foreach my $w ( keys %{$graph->{$v}} ) {

            $weight = $graph->{$v}->{$w};

            if ( !defined $distance{$w} || $distance{$w} > $distance{$v} + $weight ){

                $distance{$w} = $distance{$v} + $weight;                
            }
        }
        $dist = undef;

        foreach my $vertex ( %{$graph} ) {

            if ( (!exists $intree{$vertex}) && ( (exists $distance{$vertex} && !defined $dist) || (exists $distance{$vertex} && $distance{$vertex} < $dist) ) ){

                $dist = $distance{$vertex};
                $v = $vertex;
            }
        }
    }
return \%distance;
}


sub get_steps {
    my	( $parent,$stop_point )	= @_;

    return 0 if $parent->{ $stop_point } == -1;

    return 1 + get_steps( $parent,$parent->{ $stop_point} );
} ## --- end sub get_steps

sub create_graph {
    my	( $maze )	= @_;

    my $graph = {};
    for ( my $level=0; $level <= $#{$maze}; $level++ ) {

        for ( my $i=1; $i < $#{$maze->[$level]}; $i++ ) {

            for ( my $j = 1; $j < $#{$maze->[$level]->[$i]}; $j++ ){

                next if ( $maze->[$level]->[$i]->[$j] eq "*" );
                add_edge( $maze,$level,$graph,$i,$j );
            }
        }
    }
    return $graph;
} ## --- end sub create_graph

sub add_edge {
    my	( $maze,$level,$graph,$i,$j )	= @_;

    my $vertice1 = join ".",($level,$i,$j);

    if ( $maze->[$level]->[$i]->[$j+1] ne "*" ){

        my $vertice2 = join ".",($level,$i,$j+1);
        $graph->{$vertice1}->{$vertice2} = 1;
    }
    if ( $maze->[$level]->[$i]->[$j-1] ne "*" ){

        my $vertice2 = join ".",($level,$i,$j-1);
        $graph->{$vertice1}->{$vertice2} = 1;
    }
    if ( $maze->[$level]->[$i-1]->[$j] ne "*" ){

        my $vertice2 = join ".",($level,$i-1,$j);
        $graph->{$vertice1}->{$vertice2} = 1;
    }
    if ( $maze->[$level]->[$i+1]->[$j] ne "*" ){

        my $vertice2 = join ".",($level,$i+1,$j);
        $graph->{$vertice1}->{$vertice2} = 1;
    }
    if ( $maze->[$level]->[$i]->[$j] eq "o" ){

        my $vertice2 = join ".",($level-1,$i,$j);
        $graph->{$vertice1}->{$vertice2} = 1;
        $graph->{$vertice2}->{$vertice1} = 1;
    }
} ## --- end sub add_edge

sub find_point {
    my	( $level )	= @_;

    my $left_bound = 0;
    my $right_bound = scalar @{$level->[0]}-1;

    my $upper_bound = 0;
    my $down_bound = scalar @{$level}-1;

    my $point = {};

    for ( my $j=$left_bound; $j <= $right_bound; $j++ ) {

        if ( $level->[$upper_bound]->[$j] eq " " ){

            $point->{i} = $upper_bound+1;
            $point->{j} = $j;
            return $point;
        }

        if ( $level->[$down_bound]->[$j] eq " " ){

            $point->{i} = $down_bound-1;
            $point->{j} = $j;
            return $point;
        }
    }

    for ( my $i=$upper_bound; $i <= $down_bound; $i++ ) {

        if ( $level->[$i]->[$left_bound] eq " " ){

            $point->{i} = $i;
            $point->{j} = $left_bound+1;
            return $point;
        }

        if ( $level->[$i]->[$right_bound] eq " " ){

            $point->{i} = $i;
            $point->{j} = $right_bound-1;
            return $point;
        }
    }
} ## --- end sub find_point

sub min {
    my	( $current_level,$input_point,$i,$j )	= @_;

    return -1 if ( $input_point->{i} == $i && $input_point->{j} == $j );
    my @values = ();

    if ( $current_level->[$i+1]->[$j] ne "*" && $current_level->[$i+1]->[$j] ne " " && $current_level->[$i+1]->[$j] ne "" ){

        push @values, $current_level->[$i+1]->[$j];
    }
    if ( $current_level->[$i-1]->[$j] ne "*" && $current_level->[$i-1]->[$j] ne " " && $current_level->[$i+1]->[$j] ne "" ){

        push @values, $current_level->[$i-1]->[$j];
    }
    if ( $current_level->[$i]->[$j+1] ne "*" && $current_level->[$i]->[$j+1] ne " " && $current_level->[$i+1]->[$j] ne "" ){

        push @values, $current_level->[$i]->[$j+1];
    }
    if ( $current_level->[$i]->[$j-1] ne "*" && $current_level->[$i]->[$j-1] ne " " && $current_level->[$i+1]->[$j] ne "" ){

        push @values, $current_level->[$i]->[$j-1];
    }

    my @sorted_values = sort @values;
    return $sorted_values[0];
} ## --- end sub min

sub create_maze {
    my	( $size,$matrix, $maze )	= @_;

    my $levels = $size;

    while ( $levels > 0 ){

        my $level = [];

        for ( my $i=0; $i < $size; $i++ ) {

            my $part = [];

            for ( my $j=0; $j < $size; $j++ ) {

                push @$part, shift @$matrix;
            }
            push @$level, $part;
        }
        push @$maze, $level;
        $levels--;
    }
} ## --- end sub calc

sub show_maze {
    my	( $maze )	= @_;

    my $levels = scalar @$maze;
    my $level_size = $levels;
    my $current_level = 0;

    while ( $levels > 0 ){

        my $maze_level = $maze->[$current_level];
        for ( my $i=0;$i < $level_size; $i++ ) {

            for ( my $j=0; $j < $level_size; $j++ ) {

                print $maze_level->[$i]->[$j];
            }
            print "\n";
        }
        $current_level++;
        $levels--;
    }
} ## --- end sub show_maze
my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
