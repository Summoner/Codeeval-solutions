#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper;
use Benchmark;
#use bigint;

my $t0 = new Benchmark;

  open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
 #open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";

my @list = ();

	while(<$input>){
    	chomp;
        $_=~ s/\(//g;
        $_=~ s/\)//g;
        $_=~ s/\];*//g;
        #$_=~ s/\[//g;

        push @list,[split /;\s+/,$_];

    }
close $input;

print Dumper \@list;



foreach my $arr ( @list ) {

    my ($from,$to) = split /,/,$arr->[0];
    my @routes = split /R\d+\=\[/,$arr->[1];

    calc( $from,$to,\@routes );

}


sub calc {
    my	( $from,$to,$routes )	= @_;

    print "$from\n";
    print "$to\n";
    print join "",@$routes,"\n";
    my $graph = {};
    createGraph( $graph,$routes );

    print Dumper \$graph;
    return ;

} ## --- end sub calc

sub createGraph {
    my	( $graph,$routes )	= @_;

    my $nodes = [];
    for ( my $i = 0; $i <= $#{$routes}; $i++ ) {

        my @routePoints = split /,/,$routes->[$i];
        addNodeSameBus( $i,\@routePoints,$graph,$nodes );
        print Dumper \$nodes;
        #addNodeDifferentBuses($graph,$nodes);
    }
    return ;
} ## --- end sub createGraph


sub addNodeSameBus {
    my	( $busN,$routePoints,$graph,$nodes )	= @_;

    for ( my $i = 0; $i < $#{$routePoints}; $i++ ) {

        my $node1 = join ".",($busN,$routePoints->[$i]);
        my $node2 = join ".",($busN,$routePoints->[$i+1]);

        $graph->{$node1}->{$node2} = 7;
        push @$nodes,$node1;
        push @$nodes,$node2;
    }

    my $node1 = join ".",($busN,$routePoints->[-1]);
    my $node2 = join ".",($busN,$routePoints->[0]);

    $graph->{$node1}->{$node2} = 7;    
} ## --- end sub addNodeSameBus

sub addNodeDifferentBuses{
    my	( $graph,$nodes )	= @_;

    for ( my $i=0; $i < $#{$nodes}; $i++ ) {

        my ($bus1,$stoP1) = split /./,$nodes->[$i];
        for ( my $j = $i+1; $j <= $#{$nodes}; $j++ ) {

            my ($bus2,$stoP2) = split /./,$nodes->[$j];

            next if ( $bus1 == $bus2 );

            if ( $stoP1 == $stoP2 ){

                my $node1 = $nodes->[$i];
                my $node2 = $nodes->[$j];

                $graph->{$node1}->{$node2} = 12;
            }
        }
    }
} ## --- end sub addNodeDifferentBuses




sub dijkstra {
    my	( $graph,$startP,$stopP )	= @_;
    #$DB::single = 2;
    #place for store vertexes in multiways
    my %used = ();
    my $routes = [];
    my $existRoute = 1;

    while( $existRoute ){

        #Initialization before next route search
        my %visited = ();
        my %parent = ();
        my %distances = ();
        my $w = $startP;
        $distances{$w} = 0;
        my $distance = undef;

        while (!exists $visited{$w} ){

            $visited{$w} = 1;

            foreach my $key ( keys %{$graph->{$w}} ) {

                $distance = $graph->{$w}->{$key};
                if ( !defined $distances{$key} || $distances{$key} > $distance + $distances{$w}){

                    $distances{$key} = $distance + $distances{$w};
                    $parent{$key} = $w;
                }
            }

            $distance = undef;

            foreach my $v ( keys %distances ) {

                if ( (!defined $visited{$v}) && (!defined $used{$v}) && (!defined $distance || $distance > $distances{$v}) ){

                    $distance = $distances{$v};
                    $w = $v;
                }
            }
        }

        my $route = [];
        my $p = $stopP;
        push @$route,$p;

        while( defined $parent{$p} && $p != $startP ){

            $p = $parent{$p};
            unshift @$route,$p;
        }
        if ( $startP != $route->[0] ){

            $existRoute = 0;

        }else{

            push @$routes,$route;
            for ( my $i = 1; $i < $#{$route}; $i++ ) {

                $used{$route->[$i]}++;
            }
        }
    }
    return [] if (scalar @$routes == 0);
    my @sortedRoutes = sort { scalar @$a <=> scalar @$b } @$routes;

    my $routeSize = scalar @{$sortedRoutes[0]};

    my @resRoutes = grep { scalar @$_ <= $routeSize } @sortedRoutes;

    return \@resRoutes;
} ## --- end sub dijkstra


my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
