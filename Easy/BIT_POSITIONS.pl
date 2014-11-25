#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper; 
use Benchmark;

my $t0 = new Benchmark;
open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
# open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";



my @list = (); 
	 
	while(<$input>){			
	chomp;	
	push @list,[split /,/,$_];
	}
close $input;

#print Dumper \@list;
foreach my $arr ( @list ) {

    my $n = $arr->[0];
    my $p1 = $arr->[1];
    my $p2 = $arr->[2];

    my $bin = sprintf( "%b",$n );
    my @bin = split //,$bin;
    my @reverse_bin = reverse @bin;
    print "true\n" if ( $reverse_bin[$p1-1] == $reverse_bin[$p2-1] );
    print "false\n" if ( $reverse_bin[$p1-1] != $reverse_bin[$p2-1] );

}
my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
