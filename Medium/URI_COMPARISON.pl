#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper; 
use Benchmark;
use URI;
my $t0 = new Benchmark;
open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
# open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";

my @list = ();

while(<$input>){
	
	chomp;
	push @list, [split /;/,$_];
	
}
close $input;


foreach my $arr_ref (@list){	
		 
	my $u1 = URI->new($arr_ref->[0]);
    my $u2 = URI->new($arr_ref->[1]);
    if($u1->eq($u2)){
        print "True\n";
    }else{
        print "False\n";

    }
}


my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
