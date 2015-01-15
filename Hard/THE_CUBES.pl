#!/usr/bin/perl -d
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
    show_maze( $maze );
    find_path( $maze,$labirinth_size );
}

sub find_path {
    my	( $maze, $size )	= @_;
    # $DB::single = 2;

    my $current_level = shift @$maze;
    my $next_level;
    my $input_point = find_point( $current_level );
    my $output_point = find_point( $maze->[-1] );

    print Dumper \$input_point;
    print "******************\n";
    print Dumper \$output_point;

    my $right_bound = $size - 1;
    my $down_bound = $size - 1;
    my $steps = 0;

    if ( $input_point->{i} == 0 ){

        $input_point->{i}++;
        $steps++;

    }elsif ( $input_point->{i} == $right_bound ){

        $input_point->{i}--;
        $steps++;

    }elsif ( $input_point->{j} == 0 ){

        $input_point->{j}++;
        $steps++;

    }elsif ( $input_point->{j} == $down_bound ){

        $input_point->{j}--;
        $steps++;
    }


    while ( scalar @$maze > 0 ){

        $next_level = shift ( @$maze );

        $steps += find_shortest_path( $input_point,$current_level,$next_level,undef );

        $current_level = $next_level;

    }
    $steps += find_shortest_path( $input_point,$current_level,undef,$output_point );


} ## --- end sub find_path


sub find_shortest_path {
    my	( $input_point,$current_level,$next_level,$output_point )	= @_;

    if ( defined $output_point ){



    }elsif ( defined $next_level ){

        my @points = ();
        my $border = scalar @$current_level - 1;
        my $steps = 0;

        #Find points for next level
        for ( my $i=1;$i < scalar @{$next_level}-1;$i++ ) {

            for ( my $j=1;$j <= scalar @{$next_level->[$i]}-1;$j++ ) {

                if ( $next_level->[$i]->[$j] eq "o" ){

                    my $next_point = {};
                    $next_point->{i} = $i;
                    $next_point->{j} = $j;

                    push @points,$next_point;
                }
            }
        }

        my $graph = create_graph( $current_level );

        $steps = bfs( $input_point,$points[0],$graph );
        return $steps;



    }

} ## --- end sub find_shortest_path


sub bfs {
    my	( $start_point,$stop_point,$graph )	= @_;
    $DB::single = 2;
    my $start = join ".",($start_point->{i},$start_point->{j});
    my $stop = join ".",($stop_point->{i},$stop_point->{j});

    my @vertices = ();
    push @vertices,$start;
    my %passed = ();
    my $steps = 0;

    while ( scalar @vertices > 0 ){

        my $v1 = pop @vertices;
        $passed{$v1} = 1;

        foreach my $v2 ( keys %{$graph->{$v1}} ) {

            last if ( $v2 eq $stop );
            next if ( exists $passed{$v2} );
            $steps++;
            $passed{$v2} = 1;
            push @vertices,$v2;
        }
    }
   return $steps + 1;
} ## --- end sub bfs



sub create_graph {
    my	( $current_level )	= @_;

    my $graph = {};
    for ( my $i=1; $i < $#{$current_level}; $i++ ) {

        for ( my $j=1; $j < $#{$current_level->[$i]}; $j++ ) {

            add_edge( $current_level,$graph,$i,$j,$i-1,$j );
            add_edge( $current_level,$graph,$i,$j,$i+1,$j );
            add_edge( $current_level,$graph,$i,$j,$i,$j-1 );
            add_edge( $current_level,$graph,$i,$j,$i,$j+1 );
        }
    }
    return $graph;
} ## --- end sub create_graph

sub add_edge {
    my	( $current_level,$graph,$i1,$j1,$i2,$j2 )	= @_;

    #return if ( $i2 <0 || $j2 <0 || $i2 > $#{ $current_level } || $j2 > $#{ $current_level->[$i2] } );
    return if ( $current_level->[$i2]->[$j2] eq "*" );

    my $vertice1 = join ".",($i1,$j1);
    my $vertice2 = join ".",($i2,$j2);

    $graph->{$vertice1}->{$vertice2} = 1;
} ## --- end sub add_edge

sub find_point {
    my	( $matrix )	= @_;

    my $left_bound = 0;
    my $right_bound = scalar @{$matrix->[0]}-1;

    my $upper_bound = 0;
    my $down_bound = scalar @{$matrix}-1;

    my $point = {};

    for ( my $j=$left_bound; $j <= $right_bound; $j++ ) {

        if ( $matrix->[$upper_bound]->[$j] eq " " ){

            $point->{i} = $upper_bound;
            $point->{j} = $j;
            return $point;
        }

        if ( $matrix->[$down_bound]->[$j] eq " " ){

            $point->{i} = $down_bound;
            $point->{j} = $j;
            return $point;
        }
    }

    for ( my $i=$upper_bound; $i <= $down_bound; $i++ ) {

        if ( $matrix->[$i]->[$left_bound] eq " " ){

            $point->{i} = $i;
            $point->{j} = $left_bound;
            return $point;
        }

        if ( $matrix->[$i]->[$right_bound] eq " " ){

            $point->{i} = $i;
            $point->{j} = $down_bound;
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
