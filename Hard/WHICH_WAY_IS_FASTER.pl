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
	push @list, [split /\s+\|\s+/,$_];
}
close $input;

foreach my $arr ( @list ) {
    my $matrix = [];
    foreach my $elem ( @$arr ) {
        push @$matrix,[split//,$elem];
    }
    #showMatrix( $matrix );
    my ( $start,$finish ) = findStartAndFinish($matrix);
    my $graph = createGraph( $matrix );

    my $landPath = calcLandPath( $graph,$start,$finish );
    my $seaPath = calcSeaPath( $matrix,$graph,$start,$finish );
    if ( $landPath < $seaPath ){
        print "$landPath\n";
    }else{
        print "$seaPath\n";
    }
}

sub findStartAndFinish {
    my	( $matrix )	= @_;
    #Find start and finish
    my $start = undef;
    my $finish = undef;

    for ( my $i = 0; $i <= $#{$matrix}; $i++ ) {
        for ( my $j = 0; $j <= $#{$matrix->[$i]}; $j++ ) {
            if ( $matrix->[$i]->[$j] eq "S" ){
                $start = join "",($i,$j);
            }elsif ( $matrix->[$i]->[$j] eq "F" ){
                $finish = join "",($i,$j);
            }
        }
    }
    return ($start,$finish);
} ## --- end sub findStartAndFinish

sub findAllPorts {
    my	( $matrix )	= @_;
    #Find start and finish
    my $ports = [];

    for ( my $i = 0; $i <= $#{$matrix}; $i++ ) {
        for ( my $j = 0; $j <= $#{$matrix->[$i]}; $j++ ) {
            if ( $matrix->[$i]->[$j] eq "P" ){
                my $port = join "",($i,$j);
                push @$ports,$port;
            }
        }
    }
    return $ports;
} ## --- end sub findAllPorts

sub calcLandPath {
    my	( $graph,$start,$finish )	= @_;
    #print Dumper \$graph;
    return 2 * dijkstra( $graph,$start,$finish );
} ## --- end sub calc

sub calcSeaPath {
    #$DB::single = 2;
    my	( $matrix,$graph,$start,$finish )	= @_;
    #Find all ports
    my $ports = findAllPorts($matrix);
    my $path = 0;

    #Find nearest port to the start
    my $distanceToStart1 = dijkstra( $graph,$start,$ports->[0] );
    my $distanceToStart2 = dijkstra( $graph,$start,$ports->[1] );
    my $distanceToStart = undef;
    my $distanceToFinish = undef;

    if ( $distanceToStart1 < $distanceToStart2 ){
        $distanceToFinish = dijkstra( $graph,$ports->[1],$finish );
        $distanceToFinish *= 2;
        $distanceToStart = $distanceToStart1 * 2;

    }else{
        $distanceToFinish = dijkstra( $graph,$ports->[0],$finish );
        $distanceToFinish *= 2;
        $distanceToStart = $distanceToStart2 * 2;
    }
    #Find distance between ports on-board and landing
    my $travelBySeaDistance = dijkstra( $graph,$ports->[0],$ports->[1] );
    $path = $distanceToStart +  $travelBySeaDistance + $distanceToFinish + 2;

    return $path;
} ##--- end sub calc

sub createGraph {
    my	( $matrix )	= @_;

    my $graph = {};
    for ( my $i = 0; $i <= $#{$matrix}; $i++ ) {
        for ( my $j = 0; $j <= $#{$matrix->[$i]}; $j++ ) {
            addEdge( $matrix,$graph,$i,$j,$i+1,$j );
            addEdge( $matrix,$graph,$i,$j,$i-1,$j );
            addEdge( $matrix,$graph,$i,$j,$i,$j-1 );
            addEdge( $matrix,$graph,$i,$j,$i,$j+1 );
        }
    }
    return $graph;
} ## --- end sub createGraph

sub addEdge {
    my	( $matrix,$graph,$i1,$j1,$i2,$j2 )	= @_;

    return if (  $i2 <0 || $i2 > $#{$matrix} || $j2 < 0 || $j2 > $#{$matrix->[$i2]} );
    return if ( $matrix->[$i1]->[$j1] eq "^" || $matrix->[$i2]->[$j2] eq "^" );

    my $v1 = join "",($i1,$j1);
    my $v2 = join "",($i2,$j2);
    $graph->{$v1}->{$v2} = 2;
    $graph->{$v2}->{$v1} = 2;
} ## --- end sub addEdge

sub dijkstra {
    my	( $graph,$start,$stop )	= @_;
    my $visited = {};
    my $v = $start;
    my $parent = {};
    my $distFromStart = {};
    my $distance = undef;

    #Set all vertices visited status in 0
    foreach my $v1 ( keys %{$graph} ) {
        $visited->{$v1} = 0;
    }
    $distFromStart->{$v} = 0;
    $parent->{$start} = 0;

    while( !$visited->{$v} ){

        $visited->{$v} = 1;
        foreach my $w ( keys %{$graph->{$v}} ) {
            $distance = $graph->{$v}->{$w};
            if ( !defined $distFromStart->{$w} || ($distFromStart->{$w} > $distFromStart->{$v} + $distance) ){
                $distFromStart->{$w} = $distFromStart->{$v} + $distance;
                $parent->{$w} = $v;
            }
        }
        $distance = undef;
        foreach my $w ( keys %{$graph} ) {
            if ( !$visited->{$w} && ( defined $distFromStart->{$w} && (!defined $distance || $distance > $distFromStart->{$w}) ) ){

                $distance = $distFromStart->{$w};
                $v = $w;
            }
        }
    }
    my $count = 0;
    while( $parent->{$stop} != 0 ){
        $stop = $parent->{$stop};
        $count++;
    }
    return $count;
} ## --- end sub dijkstra

sub showMatrix {
    my	( $matrix )	= @_;

    for ( my $i = 0; $i <= $#{$matrix}; $i++ ) {
        for ( my $j = 0; $j <= $#{$matrix->[$i]}; $j++ ) {
            print "$matrix->[$i]->[$j]\t";
        }
        print "\n";
    }
} ## --- end sub showMatrix

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
