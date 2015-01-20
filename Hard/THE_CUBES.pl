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
    my $steps = find_path( $maze,$labirinth_size );
    print "$steps\n";
}

sub find_path {
    my	( $maze, $size )	= @_;
    # $DB::single = 2;

    my $current_level = shift @$maze;
    my $next_level;
    my $input_point = find_point( $current_level );
    my $output_point = find_point( $maze->[-1] );

    #print Dumper \$input_point;
    #print "******************\n";
    #print Dumper \$output_point;

    my $steps = 0;
    my $level_steps = 0;

    while ( scalar @$maze > 0 ){

        $next_level = shift ( @$maze );

        ( $level_steps,$input_point ) = find_shortest_path( $input_point,$current_level,$next_level,undef );

        return 0 if ( $level_steps == 0 );
        $current_level = $next_level;
        #print "Steps at current level: $level_steps\n";
        $steps += $level_steps;
        $steps++;
    }
    ($level_steps) = find_shortest_path( $input_point,$current_level,undef,$output_point );

    $steps += $level_steps;
    $steps += 2;
    return $steps;

} ## --- end sub find_path


sub find_shortest_path {
    my	( $input_point,$current_level,$next_level,$output_point )	= @_;

    my @points = ();
    my $steps = 0;

    if ( defined $output_point ){

        push @points,$output_point;

    }elsif ( defined $next_level ){

        my $border = scalar @$current_level - 1;
       
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
    }
    return (0,undef) if ( scalar @points == 0 );
    # $DB::single = 2;
    my $graph = create_graph( $current_level );
    #$DB::single = 2;
    my $parent = shortest_path_dijkstra( $input_point,$graph );

    #$DB::single = 2;
    my $min_steps = undef;
    my $save_point;
    foreach my $point ( @points ) {

        my $stop = join ".",($point->{i},$point->{j});
        $steps = get_steps($parent,$stop);
        if ( !defined $min_steps || $min_steps > $steps ){
             
            $min_steps = $steps;
            $save_point = $point;
        }
    }
    return ($min_steps,$save_point);
} ## --- end sub find_shortest_path


sub shortest_path_dijkstra {
    my	( $start_point,$graph )	= @_;

    my $start = join ".",($start_point->{i},$start_point->{j});
    
    my %intree = ();
    my %parent = ();
    my %distance = ();

    my $v = $start;
    my $dist = undef;
    my $w;
    my $weight;
    $distance{$v} = 0;

    foreach my $vertex ( keys %{$graph} ) {

        $parent{$vertex} = -1;
    }

    while ( !exists $intree{$v} ){

        $intree{$v} = 1;
    
        foreach my $w ( keys %{$graph->{$v}} ) {

            $weight = $graph->{$v}->{$w};

            if ( !defined $distance{$w} || $distance{$w} > $distance{$v} + $weight ){
            
                $distance{$w} = $distance{$v} + $weight;
                $parent{$w} = $v;
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
return \%parent;
} 


sub get_steps {
    my	( $parent,$stop_point )	= @_;

    return 0 if $parent->{ $stop_point } == -1;

    return 1 + get_steps( $parent,$parent->{ $stop_point} );
} ## --- end sub get_steps

sub create_graph {
    my	( $current_level )	= @_;

    my $graph = {};
    for ( my $i=1; $i < $#{$current_level}; $i++ ) {

        for ( my $j=1; $j < $#{$current_level->[$i]}; $j++ ) {

            next if ( $current_level->[$i]->[$j] eq "*" );
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

            $point->{i} = $upper_bound+1;
            $point->{j} = $j;
            return $point;
        }

        if ( $matrix->[$down_bound]->[$j] eq " " ){

            $point->{i} = $down_bound-1;
            $point->{j} = $j;
            return $point;
        }
    }

    for ( my $i=$upper_bound; $i <= $down_bound; $i++ ) {

        if ( $matrix->[$i]->[$left_bound] eq " " ){

            $point->{i} = $i;
            $point->{j} = $left_bound+1;
            return $point;
        }

        if ( $matrix->[$i]->[$right_bound] eq " " ){

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
