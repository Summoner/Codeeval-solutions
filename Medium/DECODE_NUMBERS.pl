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
	push @list, $_;
	
}
close $input;


foreach (@list){	
	
	calc($_);	
}


sub calc{

my $s = shift;

my @s = split //,$s;

my $count = 1;

foreach my $index(1..$#s){
	
	my $value = join "",$s[$index-1],$s[$index];
	$count++ if ($value <= 26);	
}


print $count,"\n";

}

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";