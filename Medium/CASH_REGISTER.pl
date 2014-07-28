#!/usr/bin/perl -d
use strict;
use warnings;
use Data::Dumper; 
use Benchmark;
use Math::Trig;

my $t0 = new Benchmark;

open my $input, "D:\\Perl\\input.txt" || die "Can't open file: $!\n";
# open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";


my @list = ();
my %coins_hash = (
0.01 => "PENNY",
0.05 => "NICKEL",
0.10 => "DIME",
0.25 => "QUARTER",
0.50 => "HALF DOLLAR",
1.00 => "ONE",
2.00 => "TWO",
5.00 => "FIVE",
10.00 => "TEN",
);
while(<$input>){
	
	chomp;
	push @list,[split /;/,$_];
	
}
close $input;


foreach (@list){
	
	
	calc($_->[0],$_->[1]);
	
}







sub calc{

	my ($val1,$val2) = @_;
	my @result_coins = ();
	print "ERROR\n" if ($val1 > $val2);
	print "ZERO\n" if ($val1 == $val2);
	
	my @coins = sort {$a <=> $b}keys %coins_hash;
	
	my $money = $val2 - $val1;
	$money = sprintf '%.2f', $money;
	$DB::single=2;
	my @current_coins = grep{$_ <= $money}@coins;
	
	while($money > 0){
		
		foreach my $coin (reverse @current_coins){
			
			if ($money >= $coin){
				
				$money -= $coin;
				push @result_coins, $coin;
			}
			
		}
		
	}
	
	foreach(@result_coins){
		
		
		print $coins_hash{$_},"\n";
		
		}
}


print "\n";
my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";