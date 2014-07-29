#!/usr/bin/perl -w
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
	
	
	print calc($_->[0],$_->[1]),"\n";
	
}







sub calc{

	my ($val1,$val2) = @_;
	my @result_coins = ();
	return "ERROR" if ($val1 > $val2);
	return "ZERO" if ($val1 == $val2);
	
	my @coins = sort {$a<=>$b}keys %coins_hash;
	
	my $money = $val2 - $val1;
	$money = sprintf ("%.2f", $money);
	 
	my @current_coins = grep{$_ <= $money}@coins;
	#$DB::single=2;
	while($money > 0){
		
		foreach my $coin(reverse @current_coins){
			
			
			$money = sprintf ("%.2f", $money);
			last if ($money == 0);
			# print $money == $coin,"\n";
			
			if ($money >= $coin){
				
				$money -= $coin;
				push @result_coins, $coin;
			}
			
		}
		
	}
	my @values = ();
	foreach(sort {$b<=>$a}@result_coins){
		
		
		push @values, $coins_hash{$_};
		
	}
	
	return join (",",@values);
}


print "\n";
my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";