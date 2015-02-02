#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper;
use Benchmark;

my $t0 = new Benchmark;

  open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
 #open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";

my $graph = {};

	while(<$input>){
    	chomp;
        my @users = ($_ =~ /(\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,6})/g);
	    $graph->{$users[0]}->{$users[1]} = 1;
	}
close $input;

#print "1----------------------------\n";
#'print Dumper \$graph;

check($graph);

sub check {
    my	( $graph )	= @_;

    my @vertices1 = keys %{$graph};
    my $clusters = {};
    my $groups = [];
    foreach my $v1 ( @vertices1 ) {

        my @vertices2 = keys %{$graph->{$v1}};
        my $cluster = [];
        foreach my $v2 ( @vertices2 ) {

            if ( exists $graph->{$v2}->{$v1} ){

                push @$cluster,$v2;
            }
        }
        $clusters->{$v1} = $cluster;
    }
    # print Dumper \$clusters;

    foreach my $v ( keys %{$clusters} ) {

       my $vertices = all_connected( $graph,$clusters->{$v} );
       push @$vertices,$v;
       push @$groups,$vertices if ( scalar @$vertices > 2 );
    }

    my $result = remove_subclusters( $groups );
    my @strings = ();

    foreach my $cluster ( @$result ) {

        push @strings, join (", ", sort {$a cmp $b}@$cluster);
    }
    my @sorted_strings = sort { $a cmp $b }@strings;

    foreach my $string ( @sorted_strings ) {

        print $string,"\n";
    }

} ## --- end sub check

sub remove_subclusters {
    my	( $groups )	= @_;

    my @sorted_groups = ();
    @sorted_groups = sort { scalar @$b <=> scalar @$a }@$groups;

    my %indexes_for_remove = ();

    for ( my $i = 0; $i < $#sorted_groups; $i++ ) {

        next if (exists $indexes_for_remove{$i} );

        for ( my $j=$i+1; $j <= $#sorted_groups; $j++ ) {

            next if (exists $indexes_for_remove{$j} );
            unless ( is_subcluster( $sorted_groups[$i],$sorted_groups[$j] ) ){

                next;
            }else{

                $indexes_for_remove{$j}++;
            }
        }
    }


    foreach my $index ( keys %indexes_for_remove ) {

        delete $sorted_groups[$index];
    }
    my @result = ();


    foreach my $cluster ( @sorted_groups ) {

        next unless defined $cluster;
        push @result,$cluster;
    }
    return \@result;
} ## --- end sub remove_subclusters


sub is_subcluster {
    my	( $cluster1,$cluster2 )	= @_;

    my %cluster1 = ();

    my $is_subcluster = 1;
    foreach my $element ( @$cluster1 ) {

        $cluster1{$element}++;
    }

    foreach my $element ( @$cluster2 ) {

        $is_subcluster = 0 unless ( exists $cluster1{$element} );
    }

    return $is_subcluster;
} ## --- end sub is_subcluster

sub all_connected {
    my	( $graph,$cluster )	= @_;

    my @indexes_for_delete = ();

    for ( my $i = 0;$i < $#{$cluster}; $i++ ) {

        my $v1 = $cluster->[$i];
        for ( my $j = $i+1;$j <= $#{$cluster}; $j++ ) {

            my $v2 = $cluster->[$j];
            unless ( defined $graph->{$v1}->{$v2} && defined $graph->{$v2}->{$v1} ){

                push @indexes_for_delete,$i;
                push @indexes_for_delete,$j;
            }
        }
    }

    foreach my $index ( @indexes_for_delete ) {

        delete $cluster->[$index];
    }
    my $vertices = [];
    for ( my $i = 0;$i <= $#{$cluster}; $i++ ) {

        next unless ( defined $cluster->[$i] );
        push @$vertices, $cluster->[$i];
    }
    return $vertices;
} ## --- end sub all_connected



my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
