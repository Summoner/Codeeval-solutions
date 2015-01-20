#!/usr/bin/perl -w
use Benchmark;

my $t0 = new Benchmark;

  open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
 #open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";

my $maze = [];

	while(<$input>){
    	chomp;
	    push @$maze,[split //,$_];
	}
close $input;

my $start_X = 0;
my $start_Y = 0;

( $start_X,$start_Y) = get_XY( $maze,1 );

#print "$start_X,$start_Y\n";

my $end_X = 0;
my $end_Y = 0;

( $end_X,$end_Y) = get_XY( $maze,-1 );

my $graph = {};

#$DB::single = 2;
create_graph( $maze );


#print Dumper \$graph->{0.1};

my $start_node = join ".",($start_Y,$start_X);

my $path = dijkstra( $graph,$start_node );

#$DB::single = 2;
draw_way( $maze,$path,$end_X,$end_Y );

show_maze( $maze );

sub dijkstra{

    my ($graph,$start) = @_;

    #if vertex in tree yet
    my %intree = ();
	#distance from current vertex to start
	my %distance = ();
	#parent vertex of current vertex
	my %parent = ();
	#current vertex;
	my $v;
	#candidate next vertex
	my $w;
	#edge weight
	my $weight;
	#best current distance from start
	my $dist = undef;

	$distance{$start} = 0;
	$v = $start;

    foreach (keys %{$graph}){

        $parent{$_} = -1;
        # $distance{$_} = LONG_MAX;
	}

    while( !exists $intree{$v} ){

        $intree{$v} = 1;
        #print "$v  $distance{$v}\n";

        foreach( keys %{$graph->{$v}} ){

            $w = $_;
            $weight = $graph->{$v}->{$w};

            if( ( !exists $distance{$w} ) || ( $distance{$w} > $distance{$v} + $weight ) ){

                $distance{$w} = $distance{$v} + $weight;
                $parent{$w} = $v;
            }
        }

        $dist = undef;

        foreach( keys %{$graph} ){

            if( ( !exists $intree{$_} ) && ( ( exists $distance{$_} && !defined $dist ) || ( exists $distance{$_} && $distance{$_} < $dist ) ) ){

                $dist = $distance{$_};
                $v = $_;
            }
        }
	}

return \%parent;
}



sub draw_way {
    my	( $maze,$path,$end_X,$end_Y )	= @_;
    my $key = join ".",($end_Y,$end_X);

       $maze->[$end_Y]->[$end_X] = "+";

    while( $path->{ $key } != -1 ){

        $key = $path->{ $key };
        my ( $i,$j ) = split /\./,$key;

        $maze->[$i]->[$j] = "+";
    }

} ## --- end sub draw_way

sub create_graph {
    my	( $maze )	= @_;

    for ( my $i=0; $i <= $#{$maze}; $i++ ) {

        for ( my $j=0; $j <= $#{$maze->[$i]}; $j++ ) {

            add_edge( $maze,$graph,$i,$j,$i-1,$j );
            add_edge( $maze,$graph,$i,$j,$i+1,$j );
            add_edge( $maze,$graph,$i,$j,$i,$j-1 );
            add_edge( $maze,$graph,$i,$j,$i,$j+1 );
        }
    }
} ## --- end sub create_graph

sub add_edge {
    my	( $maze,$graph,$i1,$j1,$i2,$j2 )	= @_;

    return if ( $i2 <0 || $j2 <0 || $i2 > $#{ $maze } || $j2 > $#{ $maze->[$i2] } );
    return if ( $maze->[$i2]->[$j2] eq "*" );

    my $vertice1 = join ".",($i1,$j1);
    my $vertice2 = join ".",($i2,$j2);

    $graph->{$vertice1}->{$vertice2} = 1;
} ## --- end sub add_edge

sub get_XY {
    my	( $maze,$direction )	= @_;

    my $x = 0;
    my $y = 0;

    if ( $direction == 1 ){

        for ( my $i=0; $i <= $#{ $maze->[0] }; $i++ ) {

            if ( $maze->[0]->[$i] eq " " ){

                $x = $i;
                $y = 0;
            }
        }
    }elsif( $direction == -1 ){

         for ( my $i=0; $i <= $#{ $maze->[-1] }; $i++ ) {

             if ( $maze->[-1]->[$i] eq " " ){

                $x = $i;
                $y = $#{$maze};
             }
         }
    }
    return ( $x,$y ) ;
} ## --- end sub get_XY

sub show_maze {
    my	( $maze )	= @_;

    for ( my $i=0; $i <= $#{$maze}; $i++ ) {

        for ( my $j=0; $j <= $#{$maze->[$i]}; $j++ ) {

            print "$maze->[$i]->[$j]";
        }
        print "\n";
    }

} ## --- end sub show_maze

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
