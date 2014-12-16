#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper;
use Benchmark;

my $t0 = new Benchmark;

  open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
  #open my $result, ">/home/fanatic/Summoner/Codeeval-solutions/output1.txt" || die "Can't open file: $!\n";

my @points = ();
my $count = 0;
	while(<$input>){
    	chomp;
        $count++;
        $_ =~ /\((\-*\d+\.\d*),\s+(\-*\d+\.\d*)\)/g;

        my $point = {};
        $point->{n} = $count;
        $point->{x} = $1;
        $point->{y} = $2;
	    push @points,$point;
	}
close $input;

#print Dumper \@points;

my $graph = {};

create_graph( $graph );

print Dumper \$graph;


sub create_graph {
    my	( $graph )	= @_;

    for ( my $i=0; $i <= $#points-1; $i++ ) {

        my $v1 = $points[$i]->{n};

        for ( my $j=$i+1; $j <= $#points ;$j++ ) {

            my $v2 = $points[$j]->{n};
            my $edge = calc_edge( $points[$i]->{x}, $points[$i]->{y},$points[$j]->{x},$points[$j]->{y} );

            $graph->{$v1}->{$v2} = $edge;
            $graph->{$v2}->{$v1} = $edge;
        }
    }

} ## --- end sub create_graph

sub calc_edge {
    my	( $x1,$y1,$x2,$y2 )	= @_;

    return sqrt ( ($x2-$x1)**2 + ($y2-$y1)**2 );
} ## --- end sub calc_edge

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
