#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper; 
use Benchmark;

my $t0 = new Benchmark;

# Center: (2.12, -3.48); Radius: 17.22; Point: (16.21, -5)
# Center: (5.05, -11); Radius: 21.2; Point: (-31, -45)
# Center: (-9.86, 1.95); Radius: 47.28; Point: (6.03, -6.42)


open my $input, "D:\\Perl\\input.txt" || die "Can't open file: $!\n";
 #open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";

my @list = (); 
	 
	while(<$input>){			
	chomp;	
	push @list,$_;
	}
close $input;


foreach(@list){
	
	
	 my @arr = $_=~ /(-*\d+(?:\.\d{0,2})*)/g;
	 
	print calc(\@arr);
}

sub calc{
	
my $arr_ref = shift;

my $center_x = $arr_ref->[0];	
my $center_y = $arr_ref->[1];
my $radius = $arr_ref->[2];
my $point_x = $arr_ref->[3];		
my $point_y = $arr_ref->[4];
	
	my $distance = sqrt(($point_x - $center_x)**2 + ($point_y - $center_y)**2);
	
	return "true\n" if $distance <= $radius;
	return "false\n";
	
}
 
my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";