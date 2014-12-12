#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper; 
use Benchmark;
use POSIX;

my $t0 = new Benchmark;

  open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
 #open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";

my @list = (); 
	 
	while(<$input>){
    	chomp;	
	    push @list,[split /\s+/,$_];
	}
close $input;

foreach my $arr ( @list ) {

    my @points = ();   
    foreach my $elem ( @$arr ) {

        my ( $x,$y ) = split /,/, $elem;
        push @points,[ $x,$y ];
    }
  create_graph( \@points );  
}

sub create_graph{

    my $points = shift;
    my $graph = {};
    my $key = 0;
    my @keys = ();

    foreach my $point ( @$points ) {

        push @keys,$key;
        $key++;
    }
        for ( my $i=0; $i < scalar @$points-1; $i++ ) {

            my $v1 = $keys[$i];

            for ( my $j=$i+1;$j < scalar @$points; $j++ ) {

                my $v2 = $keys[$j];
                my $e = calc_edge( $points->[$i]->[0], $points->[$i]->[1], $points->[$j]->[0], $points->[$j]->[1]);
                $graph->{$v1}->{$v2} = $e;
                $graph->{$v2}->{$v1} = $e;
            }            
        }

    prim_alg( $graph,0);
}

sub prim_alg {
    my ( $graph,$column_start )	= @_;
  
    my @nodes = keys %{$graph};
    # print join (" ",sort @nodes),"\n";
    my $column = $column_start;
    my @columns = ();
    my @edges = ();
    my $edge = 0;
    my $matrix = [];
    
    for ( my $i=0; $i < scalar @nodes; $i++ ) {

        for ( my $j=0; $j < scalar @nodes; $j++ ) {

            $matrix->[$i]->[$j] = 0 if ( $i == $j );
            $matrix->[$i]->[$j] = $graph->{ $nodes[$i] }->{ $nodes[$j] } || 0;
        }
    }

    push @columns, $column;

    while( scalar @columns < scalar @nodes ){

        delete_row( $matrix, $column );
        ( $column,$edge ) = get_min( $matrix, \@columns );
        push @columns, $column;
        push @edges, $edge;
    }
    
    my $result = 0;
    
    foreach my $edge ( @edges ) {

        $result += $edge;
    }
    print ceil($result),"\n";
} ## --- end sub prim_alg

sub get_min {
    my	( $matrix, $columns )	= @_;

    my $min = undef;
    my $row = 0;

    foreach my $column ( @$columns ) {

        for ( my $i = 0; $i <= $#{ $matrix }; $i++ ) {

            next if ( $matrix->[$i]->[$column] == 0 );

            if ( !defined $min || $min > $matrix->[$i]->[$column] ){
            
                $min = $matrix->[$i]->[$column];
                $row = $i;            
            }
        }
    }
    return ( $row,$min );
} ## --- end sub get_min

sub delete_row {
    my	( $matrix,$i )	= @_;
    
    for ( my $j=0; $j <= $#{$matrix->[$i]}; $j++) {

        $matrix->[$i]->[$j] = 0;
    }
} ## --- end sub delete_row

sub calc_edge {
    my	( $x1,$y1,$x2,$y2 )	= @_;

    return sqrt ( ( $x2 - $x1 )**2 + ( $y2 - $y1 )**2 ) ;
} ## --- end sub calc_edge

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
