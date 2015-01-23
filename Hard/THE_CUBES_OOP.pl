#!/usr/bin/perl -w
package Element;

use strict;
use warnings;
use Data::Dumper;
use Benchmark;

my $element = {};
   $element->{WALL} = 1;
   $element->{HOLE} = 2;
   $element->{FLOOR} = 3;

sub get_wall{

    return $element->{WALL};
}

sub get_hole{

    return $element->{HOLE};
}

sub get_floor{

    return $element->{FLOOR};
}


sub char_to_element {
    my	($class,$input )	= @_;

    return 1 if ($input eq "*");
    return 2 if ($input eq "o");
    return 3 if ($input eq " ");
} ## --- end sub char_to_element


package Graph;

sub new {
    my	( $class )	= @_;
    my $self = {};

    bless ( $self,$class );

} ## --- end sub new

sub add_edge {
    my	( $self, $v1, $v2 )	= @_;
    
    $self->{$v1}->{$v2} = 1;
    $self->{$v2}->{$v1} = 1;

#    $DB::single = 2;
    return;
} ## --- end sub add_edge
1;

package Point;

sub new {
    my $class = shift @_;
    my $self = {
        level => shift @_,
        row => shift @_,
        column => shift @_
    };

    bless($self,$class);
} ## --- end sub new


sub level {
    ( $_[0]->{level} = $_[1] ) if defined  $_[1] ; return $_[0]->{level};
} ## --- end sub level

sub row {
    ( $_[0]->{row} = $_[1] ) if defined  $_[1] ; return $_[0]->{row};
} ## --- end sub row

sub column {
    ( $_[0]->{column} = $_[1] ) if defined  $_[1] ; return $_[0]->{column};
} ## --- end sub column

sub adjacent_to {
    my	( $self, $point )	= @_;
    return abs($self->level - $point->level ) + abs($self->row - $point->row ) + abs($self->column - $point->column ) == 1 ;
} ## --- end sub adjacent_to


sub adjacent_points {
    my	( $self )	= @_;
    return [
            Point->new( $self->level-1,$self->row,$self->column ),
            Point->new( $self->level+1,$self->row,$self->column ),
            Point->new( $self->level,$self->row-1,$self->column ),
            Point->new( $self->level,$self->row+1,$self->column ),
            Point->new( $self->level,$self->row,$self->column-1 ),
            Point->new( $self->level,$self->row,$self->column+1 )
    ];
} ## --- end sub adjacent_points


sub equal_to {
    my	( $self,$other_point )	= @_;

    return $self->level == $other_point->level && $self->row == $other_point->row && $self->column == $other_point->column ;
} ## --- end sub equal

1;

package Cube;

sub new {
    my $class = shift @_;

    my $self = shift @_;

    bless( $self, $class );
} ## --- end sub new

sub length {

    my $self = shift;
    return scalar @{$self};
} ## --- end sub length


sub _find_empty_cell_in_border {
    my	( $self,$level )	= @_;

    foreach my $j ( 0..$self->length-1 ) {

        return Point->new( $level, 0,$j )  if ( $self->[$level]->[0]->[$j] eq " " );
        return Point->new( $level, $self->length-1,$j ) if ( $self->[$level]->[$self->length-1]->[$j] eq " " );
    }

    foreach my $i ( 0..$self->length-1 ) {

        return Point->new( $level, $i,0 ) if ( $self->[$level]->[$i]->[0] eq " " );
        return Point->new( $level, $i,$self->length-1 ) if ( $self->[$level]->[$i]->[$self->length - 1] eq " " );
    }

    return undef;
} ## --- end sub _find_empty_cell_in_border

sub entrance {
    my	( $self )	= @_;
    return $self->_find_empty_cell_in_border( 0 ) ;
} ## --- end sub entrance


sub exit {
    my	( $self )	= @_;

    return $self->_find_empty_cell_in_border( $self->length-1 ) ;
} ## --- end sub exit


sub _element {
    my	( $self,$point )	= @_;
    #$DB::single = 2;
    if ( $point->level < 0 || $point->row < 0 || $point->column < 0 ||$point->level >= $self->length || $point->row >= $self->length || $point->column >= $self->length ){

            return Element->get_wall;
     }
    return Element->char_to_element( $self->[$point->level]->[$point->row]->[$point->column] );
} ## --- end sub _element


sub _can_travel {
    my	( $self, $point_from,$point_to )	= @_;
    #$DB::single = 2;
    return 0  if ( $self->_element($point_from) == Element->get_wall || $self->_element($point_to) == Element->get_wall );

    return 0 unless ( $point_from->adjacent_to($point_to));

    if ( $point_from->level == $point_to->level ){

        return 1;

    }elsif ( $point_from->level - $point_to->level == 1 ){

        return 1 if ( $self->_element( $point_from ) == Element->get_hole );

    }elsif ( $point_to->level - $point_from->level == 1 ){
        
        return 1 if ( $self->_element( $point_to ) == Element->get_hole );

    }else{

        return 0;
    }
} ## --- end sub _can_travel


sub _create_graph {
    my	( $self,$visited,$graph,$current_point )	= @_;

    my $current = join "",( $current_point->level,$current_point->row,$current_point->column );

    return if ( exists $visited->{$current} );

    $visited->{$current} = 1;

#$DB::single = 2;
    foreach my $next_point ( @{$current_point->adjacent_points()} ) {

        if ( $self->_can_travel( $current_point,$next_point ) ){

            my $next = join "",( $next_point->level,$next_point->row,$next_point->column );

            $graph->add_edge($current,$next );
            # $DB::single = 2;
            $self->_create_graph( $visited,$graph,$next_point );
        }
    }
    return $graph;
} ## --- end sub _create_graph

sub graph {
    my	( $self )	= @_;

    my $visited = {};
    my $graph = Graph->new();
    $self->_create_graph( $visited,$graph,$self->entrance() );
    #  $DB::single = 2;
    return $graph;
} ## --- end sub graph
1;

use Data::Dumper;

open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
#open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";

my @list = ();

	while(<$input>){
    	chomp;
	    push @list,[split /;/, $_];
	}
close $input;

foreach my $arr ( @list ) {

    my $labirinth_size = $arr->[0];
    my @matrix = split //,$arr->[1];
    my $levels = [];

    while ( scalar @matrix > 0 ){

        foreach ( 0..$labirinth_size-1 ) {

            my $level = [];
            foreach ( 0..$labirinth_size-1 ) {
            
                my $part = [];
                foreach ( 0..$labirinth_size-1 ) {

                    push @$part,shift @matrix;
                }
                 push @$level,$part;
            }
            push @$levels,$level;
        }
    }
#$DB::single = 2;
my $cube = Cube->new( $levels );

my $visited = dijsktra( $cube->graph,$cube->entrance );

my $point = $cube->exit();

my $p = join "",($point->level,$point->row,$point->column);

if ( defined $visited->{$p} ){

    print 1 + $visited->{$p},"\n";
}else{

    print "0\n";
}

}

sub dijsktra {
    my	( $graph,$start_point )	= @_;

    my $visited = {};
    my $start = join "",($start_point->level,$start_point->row,$start_point->column); 
    $visited->{$start} = 0;
    my $path = {};
    my $nodes = {};

    foreach my $node ( keys %{$graph} ) {

        $nodes->{$node}++;
    }

    while( scalar keys %{$nodes} > 0 ){

        my $min_node = undef;

        foreach my $node ( keys %{$nodes} ) {

            if ( exists $visited->{$node} ){

                unless ( defined $min_node ){

                    $min_node = $node;

                }elsif( $visited->{$node} < $visited->{$min_node} ){

                    $min_node = $node;
                }
            }
        }
        last unless ( defined $min_node );
        delete $nodes->{$min_node};
        my $current_weight = $visited->{$min_node};

        foreach my $n (keys %{$graph->{$min_node}} ) {

                my $weight = $current_weight + $graph->{$min_node}->{$n};
                if ( !exists $visited->{$n}  || $weight < $visited->{$n} ){

                    $visited->{$n} = $weight;
                    $path->{$n} = $min_node;
                }
        }
    }
    return $visited;
} ## --- end sub dijsktra

