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

#print Dumper \@list;



foreach my $arr ( @list ) {

    my ($from,$to) = split /,/,$arr->[0];
    my @routes = split ( /\s*R\d+\=\[/,$arr->[1] );
    shift @routes;
#print Dumper \@routes;
    print calc( $from,$to,\@routes ),"\n";

}


sub calc {
    my	( $from,$to,$routes )	= @_;

    #print "$from\n";
    #print "$to\n";
    #print join "|",@$routes,"\n";
    my $graph = {};
    my $nodes = [];

    createGraph( $graph,$routes,$nodes );
    #print Dumper \$graph;
    my ( $inputs,$outputs ) = formInputsOutputs( $nodes,$from,$to );
    my $res = dijkstra( $graph,$inputs,$outputs );

    if ( defined $res ){

        return $res;

    }else{

        return "None";
    }
} ## --- end sub calc

sub createGraph {
    my	( $graph,$routes,$nodes )	= @_;
#$DB::single = 2;

    for ( my $i = 0; $i <= $#{$routes}; $i++ ) {

        my @routePoints = split /,/,$routes->[$i];
        #       print Dumper \@routePoints;
        addNodeSameBus( $i+1,\@routePoints,$graph,$nodes );
        #print Dumper \$nodes;
    }
    addNodeDifferentBuses($graph,$nodes);

} ## --- end sub createGraph

sub addNodeSameBus {
    my	( $busN,$routePoints,$graph,$nodes )	= @_;
#$DB::single = 2;

    my $part1 = join "",("bus",$busN);
    for ( my $i = 0; $i < $#{$routePoints}; $i++ ) {

        my $part2 = join "",("stop",$routePoints->[$i]);
        my $part3 = join "",("stop",$routePoints->[$i+1]);

        my $node1 = join ".",($part1,$part2);
        my $node2 = join ".",($part1,$part3);

        $graph->{$node1}->{$node2} = 7;
        #push @$nodes,$node1;
        push @$nodes,$node2;
    }

    my $part2 = join "",("stop",$routePoints->[-1]);
    my $part3 = join "",("stop",$routePoints->[0]);

    my $node1 = join ".",($part1,$part2);
    my $node2 = join ".",($part1,$part3);

    push @$nodes,$node2;
    $graph->{$node1}->{$node2} = 7;
} ## --- end sub addNodeSameBus

sub addNodeDifferentBuses{
    my	( $graph,$nodes )	= @_;
#$DB::single = 2;
    for ( my $i=0; $i < $#{$nodes}; $i++ ) {

        my ($bus1,$stoP1) = split /\./,$nodes->[$i];

        for ( my $j = $i+1; $j <= $#{$nodes}; $j++ ) {

            my ($bus2,$stoP2) = split /\./,$nodes->[$j];

            next if ( $bus1 eq $bus2 );

            if ( $stoP1 eq $stoP2 ){

                my $node1 = $nodes->[$i];
                my $node2 = $nodes->[$j];

                $graph->{$node1}->{$node2} = 12;
                $graph->{$node2}->{$node1} = 12;
            }
        }
    }
} ## --- end sub addNodeDifferentBuses

sub formInputsOutputs {
    my	( $nodes,$inp,$outp )	= @_;

    my $inputs = [];
    my $outputs = [];

    $inp = join "",("stop",$inp);
    $outp = join "",("stop",$outp);


    foreach my $node ( @$nodes ) {

        my ($bus,$stop) = split /\./,$node;
        if ( $stop eq $inp ){

            push @$inputs,$node;

        }elsif( $stop eq $outp ){

            push @$outputs,$node;
        }
    }
    return ($inputs,$outputs);
} ## --- end sub formInputsOutputs

sub dijkstra {
    my	( $graph,$inputs,$outputs )	= @_;

    my $resultMin = undef;
    foreach my $startP ( @$inputs ) {

        foreach my $stopP ( @$outputs ) {

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

                    if ( (!defined $visited{$v})  && (!defined $distance || $distance > $distances{$v}) ){

                        $distance = $distances{$v};
                        $w = $v;
                    }
                }
            }
#$DB::single = 2;
            my $route = [];
            my $currentMin = 0;
            my $p = $stopP;
            push @$route,$p;

            while( defined $parent{$p} && $p ne $startP ){

                $p = $parent{$p};
                unshift @$route,$p;
            }
            unless ( $startP eq $route->[0] ){

                next;
            }

            for ( my $i=0; $i < $#{$route}; $i++ ) {

                $currentMin += $graph->{$route->[$i]}->{$route->[$i+1]};
                #print "$currentMin\n";

            }

            if ( !defined $resultMin || $resultMin > $currentMin ){

                $resultMin = $currentMin;
            }
            # print "################################################################\n";
            #print $startP,"\n";
            # print $stopP,"\n";
            #print join " ",@$route,"\n";
            #print Dumper \%parent;
            #print $currentMin,"\n";
            #print "################################################################\n";


        }
    }
    return $resultMin;
} ## --- end sub dijkstra


my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
