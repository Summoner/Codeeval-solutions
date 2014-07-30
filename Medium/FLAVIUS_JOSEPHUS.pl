#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper; 
use Benchmark;

my $t0 = new Benchmark;


open my $input, "D:\\Perl\\input.txt" || die "Can't open file: $!\n";
# open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";

my @list = ();

while(<$input>){
	
	chomp;
	push @list, [split /,/,$_];
	
}
close $input;


foreach (@list){	
		 
	calc($_->[0],$_->[1]);	
}



sub calc{

	my ($n,$step) = @_;
	
	my @people = ();
	my @result = ();
	for (my $i = 0; $i < $n; $i++){
				
		$people[$i] = 1;		
	}
	
	my $index = -1;	  
	
	while(1){
		
		last if (scalar @people == scalar @result);
		my $count = 0;
		
		while($count < $step){
			
			$index = ($index + 1) % $n;
			$count++ if ($people[$index]);	
			
		}
		$people[$index] = 0;		
		push @result,$index;
		
	}	
	print join " ",@result,"\n"; 
}
my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";