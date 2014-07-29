#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper; 
use Benchmark;

my $t0 = new Benchmark;

my @coins = (5,3,1);
open my $input, "D:\\Perl\\input.txt" || die "Can't open file: $!\n";
# open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";


 my @list = ();

 while(<$input>){
	
	 chomp;
	 push @list, $_;
	
  }
 close $input;


  foreach (@list){
	
	
	 print calc($_,0),"\n";
	
  }




sub calc{
	
	my $input = shift;
	my $count = shift;
	return $count if ($input == 0);
	foreach(@coins){
		
		if ($_ == $input){
			
			$count++;
			return $count;
		}
		
	}
	
	
	if ($input > 5){
		
		$count = int($input /5);
		my $part = $input % 5;			
		calc($part,$count);
			
	}elsif($input > 3){
		
		$count = int($input /3);
		my $part = $input % 3;			
		calc($part,$count);		
	}elsif($input > 1){
		
		$count = int($input /1);
		my $part = $input % 1;			
		calc($part,$count);		
	}
	
	
}



my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";