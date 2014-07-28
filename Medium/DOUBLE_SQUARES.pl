#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper; 
use Benchmark;
use Math::Trig;

my $t0 = new Benchmark;

open my $input, "D:\\Perl\\input.txt" || die "Can't open file: $!\n";
# open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";
# 5
# 10
# 25
# 3
# 0
# 1

my @list = ();
while(<$input>){
	
	chomp;
	push @list,$_;
	
}
close $input;


my $test_cases = shift @list;

foreach(@list){
	
	print double_square($_),"\n";
	
	
	}



sub double_square{
	
	my $M = shift;	
	my $p = int sqrt($M/2);
	my $total = 0;
	
	for(my $i = 0; $i <= $p; $i++){
		
		my $j = sqrt($M - $i * $i);
		
		$total++ if ($j - int $j == 0);
		
	}
	
	return $total;
	
}

print "\n";
my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";