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
Proceed( \@points,$list[0] );

sub Proceed {
    my	( $points,$arr )	= @_;

    my $graph = CreateGraph($arr);
#    print "********************************\n";
#    print Dumper \$graph;
#    print "********************************\n";

    foreach my $point ( @$points ) {

        my $startP = $point->[0];
        my $stopP = $point->[1];
        my $routes = [];
        my $minRouteSize = GetMinRouteSize( $graph,$startP,$stopP );

        Deep( $graph,[],$startP,$stopP,$routes );

        if ( scalar @$routes == 0 ){

            print "No connection\n";
            next;
        }

        $routes = GetMinRoutes( $routes );
        my @strings = ();
        foreach my $route ( @$routes ) {

            my $routeStr = join ", ",@$route;
            my $str = "[" . $routeStr . "]";
            push @strings, $str;
        }
        print join (",",@strings),"\n";
    }
    return;
} ## --- end sub proceed

sub CreateGraph{
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

            FindEqualSubnets( $hosts[$i],$hosts->{$hosts[$i]},$hosts[$j],$hosts->{$hosts[$j]},$graph);
        }
    }
    #print Dumper \$graph;
    return $graph;
}

sub FindEqualSubnets {
    my	( $host1,$interfaces1,$host2,$interfaces2,$graph )	= @_;

    #$DB::single = 2;
    foreach my $interface1 ( @$interfaces1 ) {

        foreach my $interface2 ( @$interfaces2 ) {

            if ( InSameSubnet( $interface1,$interface2 ) ){

                # print "match!!!!! \n";
                #print "$interface1: $convertedInterface1 <-----> $interface2: $convertedInterface2\n";

                $graph->{$host1}->{$host2} = 1;
                $graph->{$host2}->{$host1} = 1;
            }
        }
    }
}

sub InSameSubnet{

    my ( $interface1,$interface2 ) = @_;
    my ( $ip1,$mask1 ) = split /\//,$interface1;
    my ( $ip2,$mask2 ) = split /\//,$interface2;

#    print "ip: $ip -----> mask: $mask\n";
    $mask1 = MaskConvertToDec( $mask1 );
    $mask2 = MaskConvertToDec( $mask2 );

#    print "ip: $ip -----> mask: $mask\n";
    $ip1 = IpConvertToBin( $ip1 );
    $ip2 = IpConvertToBin( $ip2 );

    $mask1 = IpConvertToBin( $mask1 );
    $mask2 = IpConvertToBin( $mask2 );

#    print "ip: $ip -----> mask: $mask\n";
    my $subnet1 = $ip1 & $mask1;
    my $subnet2 = $ip2 & $mask2;

#    print "ip1:     $ip1 -----> ip2:     $ip2\n";
#    print "mask1:   $mask1 -----> mask2:   $mask2\n";
#    print "subnet1: $subnet1 -----> subnet2: $subnet2\n";

    return 1 if ( SameSubnet( $subnet1, $subnet2 ) );
    return 0;
#    print "subnet: $subnet\n";
} ## --- end sub calc

sub MaskConvertToDec {
    my	( $mask )	= @_;

    my $_bit = (2 ** (32 - $mask) - 1);
    my $fullMask = unpack ("N", pack ("C4",split (/\./,'255.255.255.255')) );
    my $netMask = join ".",unpack ("C4", pack ("N",( $fullMask ^ $_bit)) );

    return $netMask;
} ## --- end sub maskConvertToDec

sub SameSubnet {
    my	( $subnet1,$subnet2 )	= @_;

    my @subnet1 = split //,$subnet1;
    my @subnet2 = split //,$subnet2;
    for ( my $i = 0; $i <= $#subnet1; $i++ ) {

        unless ( $subnet1[$i] == $subnet2[$i] ){
            return 0;
        }
    }
    return 1;
} ## --- end sub SameSubnet

sub DecConvertToBin {
    my	( $dec )	= @_;

    return unpack("B32",pack("N",$dec));
} ## --- end sub decConvertToBin

sub IpConvertToBin {
    my	( $ip )	= @_;

    return join ("",map { substr( unpack("B32",pack("N",$_)),-8)}split(/\./,$ip));

} ## --- end sub ipConvertToBin

sub Deep {
    my	( $graph,$path,$v,$stopV,$routes )	= @_;

#    $DB::single = 2;

    my @path = @$path;
    push @path,$v;
    my %path = ();

    if ( $v == $stopV ){

        push @$routes,\@path;
        return;
    }

    grep{ $path{$_} = 1 }@path;

    foreach my $w ( keys %{ $graph->{$v} } ) {

        next if ( exists $path{ $w } );
        Deep( $graph,\@path,$w,$stopV,$routes );
    }
    return ;
} ## --- end sub Deep


sub GetMinRouteSize {
    my	( $graph,$startP,$stopP )	= @_;
    
    my $minRouteSize = Dijkstra( $graph, $startP,$stopP );
    return $minRouteSize;
} ## --- end sub GetMinRoutes

sub Dijkstra {
    my	( $graph,$startP,$stopP )	= @_;
    
        #Initialization
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

                if ( !exists $visited{$v} && ( (exists $distances{$v} && !defined $distance) || (exists $distances{$v} && $distance > $distances{$v}) ) ){

                    $distance = $distances{$v};
                    $w = $v;
                }
            }
        }
        my $current = $stopP;
        my $path = [];
        push @$path,$stopP;

        while ( defined $parent{$current} ){
            push @$path, $parent{$current};
            $current = $parent{$current};
        }
        return scalar @$path;
} ## --- end sub dijkstra


my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
