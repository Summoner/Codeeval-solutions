#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper;
use Benchmark;

my $t0 = new Benchmark;

  open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
 #open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";

my @list = ();
my @vertices = ();
	while(<$input>){
    	chomp;
	    push @list,[split /;/,$_];
	}
close $input;

foreach my $arr ( @list ) {

    @vertices = split /,/,$arr->[1];
    createGraph( \@vertices );
}


sub createGraph {
    my	( $vertices )	= @_;

    my $graph = {};

    foreach my $vertice ( @$vertices ) {

        my ( $v1,$v2 ) = split /\s+/,$vertice;
        $graph->{$v1}->{$v2} = 1;
        $graph->{$v2}->{$v1} = 1;
    }
    







#    print Dumper \$graph;
#
#
#
#
} ## --- end sub createGraph


my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
