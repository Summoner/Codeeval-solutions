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
	    push @list,[split /;/,$_];
	}
close $input;

#print Dumper \@list;
foreach my $arr ( @list ) {

    my $graph = {};
    my @edges = split /,/,$arr->[1];
    #print Dumper \@edges;
    $graph = createGraph( \@edges );
    print calc( $graph ),"\n";
}

sub calc {
    my	( $graph )	= @_;
    my $v = scalar keys %$graph;
    my $a = [];
    my $b = [];
    my $c = [];
    my $d = [];
    my $summ = 0;

    for ( my $i = 0; $i < $v; $i++ ) {
        for ( my $j=0; $j < $v; $j++ ) {
            $a->[$i]->[$j] = 0;
            $b->[$i]->[$j] = 0;
            $c->[$i]->[$j] = 0;
            $d->[$i]->[$j] = 0;
        }
    }
    #Form adjascency matrix
    my @vertexes = keys %$graph;
    for ( my $i = 0; $i < $v; $i++ ) {
        for ( my $j = 0; $j < $v; $j++ ) {
            next if ( $i == $j );
            if ( exists $graph->{$vertexes[$i]}->{$vertexes[$j]}){
                $a->[$i]->[$j] = 1;
            }
        }
    }
#    showMatrix($a);
    for ( my $i = 0; $i < $v; $i++ ) {
        for ( my $j = 0; $j < $v; $j++ ) {
            $b->[$i]->[$j] = $a->[$i]->[$j];
        }
    }
    #Multiplication of matrix (a * a)
    for ( my $i = 0; $i < $v; $i++ ) {
        for ( my $j = 0; $j < $v; $j++ ) {
            for ( my $k = 0; $k < $v; $k++ ) {
                $c->[$i]->[$j] = $c->[$i]->[$j] + ($a->[$i]->[$k] * $b->[$k]->[$j]);
            }
        }
    }

    for ( my $i = 0; $i < $v; $i++ ) {
        for ( my $j = 0; $j < $v; $j++ ) {
            for ( my $k = 0; $k < $v; $k++ ) {
                $d->[$i]->[$j] = $d->[$i]->[$j] + ($a->[$i]->[$k] * $c->[$k]->[$j]);
            }
        }
    }

    for ( my $i = 0; $i < $v; $i++ ) {
        for ( my $j = 0; $j < $v; $j++ ) {
            if ($i == $j){
                $summ += $d->[$i]->[$j];
            }
        }
    }

    return $summ/6;
} ## --- end sub calc

sub createGraph {
    my	( $edges )	= @_;
    my $graph = {};

    foreach my $edge ( @$edges ) {
        my ( $v1,$v2 ) = ( split /\s+/,$edge );
        $graph->{$v1}->{$v2} = 1;
        $graph->{$v2}->{$v1} = 1;
    }
#    print Dumper \$graph;
    return $graph;
} ## --- end sub createGraph

sub showMatrix {
    my	( $matrix )	= @_;

    for ( my $i = 0; $i < scalar @$matrix; $i++ ) {
        for ( my $j=0; $j < scalar @{$matrix->[$i]}; $j++ ) {
            print $matrix->[$i]->[$j],"\t";
        }
        print "\n";
    }
} ## --- end sub showMatrix

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
