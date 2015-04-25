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
my $count = 0;
my @points = ();
	while(<$input>){
    	chomp;
        if ( $count == 0 ){

            $_=~ s/\{//g;
            $_=~ s/\}//g;
            $_=~ s/\'//g;
            $_=~ s/\[//g;

            push @list,[split /\],*\s*/,$_];
            $count++;

        }else{

            push @points, [split /\s+/,$_]
        }
	}
close $input;

#print Dumper \@list;
proceed( \@points,$list[0] );

sub proceed {
    my	( $points,$arr )	= @_;

    my $graph = createGraph($arr);
    print "********************************\n";
    print Dumper \$graph;
    print "********************************\n";

    foreach my $point ( @$points ) {

        my $startP = $point->[0];
        my $stopP = $point->[1];
        my $routes = dijkstra($graph,$startP,$stopP);

        if ( scalar @$routes == 0 ){

            print "No connection\n";
            next;
        }
        foreach my $route ( @$routes ) {

            print join ",",@$route;
            print "       ";
        }
        print "\n";
    }
    return;
} ## --- end sub proceed


sub createGraph{
    my $arr = shift;

    my $hosts = {};

    foreach my $elem ( @$arr ) {

        my ($host,$interfacesStr) = (split /:\s*/,$elem);

        $hosts->{$host} = [split /,\s*/,$interfacesStr];
    }
#print Dumper \$hosts;
    my $graph = {};
    my @hosts = keys %$hosts;

    for ( my $i=0; $i < $#hosts; $i++ ) {

        for ( my $j=$i+1; $j <= $#hosts; $j++ ) {

            calc( $hosts[$i],$hosts->{$hosts[$i]},$hosts[$j],$hosts->{$hosts[$j]},$graph);
        }
    }
    #print Dumper \$graph;
    return $graph;
}

sub calc {
    my	( $host1,$interfaces1,$host2,$interfaces2,$graph )	= @_;

    #$DB::single = 2;
    foreach my $interface1 ( @$interfaces1 ) {

        my $convertedInterface1 = convert( $interface1 );

        foreach my $interface2 ( @$interfaces2 ) {

            my $convertedInterface2 = convert( $interface2 );

            print "$interface1: $convertedInterface1 <-----> $interface2: $convertedInterface2\n";
            #if ( areEqual( $convertedInterface1,$convertedInterface2 ) ){
            if ( $convertedInterface1 == $convertedInterface2 ){

                # print "match!!!!! \n";
                #print "$interface1: $convertedInterface1 <-----> $interface2: $convertedInterface2\n";

                $graph->{$host1}->{$host2} = 1;
                $graph->{$host2}->{$host1} = 1;
                return;
            }
        }
    }
}

sub areEqual {
    my	( $arr1,$arr2 )	= @_;

    return 0 unless ( scalar @$arr1 == scalar @$arr2 );

    for ( my $i = 0; $i <= $#{$arr1}; $i++ ) {

        unless ( $arr1->[$i] == $arr2->[$i] ){

            return 0;
        }
    }
    return 1;
} ## --- end sub areEqual

sub convert{

    my $input = shift;
    #my $input = "67.239.38.85/23";
    my ( $ip,$mask ) = split /\//,$input;

#    print "$ip -----> $mask\n";
    $mask = maskConvertToDec($mask);
    #print "$ip -----> $mask\n";
    $ip = ipConvertToBin($ip);
    $mask = ipConvertToBin($mask);
    #   print "$ip -----> $mask\n";

    ###########################################
    $ip = bin2dec($ip);
    $mask = bin2dec($mask);
    return $ip * $mask;

    ##########################################
    #return [split //, $ip * $mask];
} ## --- end sub calc

sub bin2dec{

    return oct("0b".shift);
}


#sub bin2dec {
#    my	( $input )	= @_;

#    return unpack( "N",pack("B32",substr("0" x 32 . shift ,-32)));
#} ## --- end sub bin2dec

sub maskConvertToDec {
    my	( $mask )	= @_;

    my $_bit = (2 ** (32 - $mask) - 1);
    my $fullMask = unpack ("N", pack ("C4",split (/\./,'255.255.255.255')) );
    my $netMask = join ".",unpack ("C4", pack ("N",( $fullMask ^ $_bit)) );

    return $netMask;
} ## --- end sub maskConvertToDec

sub ipConvertToBin {
    my	( $ip )	= @_;

    return join ("",map { substr( unpack("B32",pack("N",$_)),-8)}split(/\./,$ip));

} ## --- end sub ipConvertToBin

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
