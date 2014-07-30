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
		 
	 if (isRotation($_->[0],$_->[1])){
	 	
	 	print "True\n";
	 }else{
	 		
	 	print "False\n";	
	 }
}


sub isRotation {
 my($string1,$string2) = @_;
 return length($string1) == length($string2) && ($string1.$string1)=~/$string2/;
}



my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";