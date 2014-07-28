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
while(<$input>){
	
	chomp;
	push @list,[split /;/,$_];
	
}
close $input;


foreach (@list){
	
	
	
	
}


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




sub calc{

	my ($val1,$val2) = @_;
	
	print "ERROR\n" if ($val1 > $val2);
	print "ZERO\n" if ($val1 == $val2);
	
	my @coins = sort {$a <=> $b}keys %coins_hash;
	
	my $money = $val1 - $val2;
	
	my @current_coins = grep{$_ <= $money}@coins;
	
}


print "\n";
my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";