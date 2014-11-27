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
        chomp $_;	
	    push @list,[split //,$_];
	}
close $input;

#print Dumper \@list;
foreach my $arr ( @list ) {
    
    my $summ = 0;


    foreach my $n ( @$arr ) {

        $summ += $n;
    }
 print "$summ\n";
} 
my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
