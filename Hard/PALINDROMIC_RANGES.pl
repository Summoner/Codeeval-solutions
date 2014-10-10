#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper; 
use Benchmark;


my $t0 = new Benchmark;

open my $input, "D:\\Perl\\input.txt" || die "Can't open file: $!\n";
# open my $result, ">D:\\Perl\\output.txt" || die "Can't open file: $!\n";


my @list = ();
while(<$input>){
	
	chomp;
	push @list,[split / /,$_];
	
}
close $input;

foreach(@list){
	
	my $left_bound = $_->[0];
	my $right_bound = $_->[-1];
	my $ranges = 0;
	
	for (my $i = $left_bound; $i< $right_bound; $i++){
		
		for (my $j = $i+1; $j<= $right_bound; $j++){
		
			$ranges++ if (is_even_primes($i,$j));
		
		}		
	}	
	
	print $ranges,"\n";
}

sub is_even_primes{
	
	my($left_bound,$right_bound) = @_;
	my $count = 0;
	while ($left_bound <= $right_bound){
		
		$count++ if is_palindrom($left_bound);
		$left_bound++;
		
	}
	
	return 1 if($count % 2 == 0);
	return 0;
}
	
	
sub is_palindrom{

    my $input = shift;
	my $reverse_input = reverse $input;
	return 1 if ($input == $reverse_input);
	return 0;
}


print "\n";
my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
