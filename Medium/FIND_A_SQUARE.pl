#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper; 
use Benchmark;

my $t0 = new Benchmark;

# (1,6), (6,7), (2,7), (9,1)
# (4,1), (3,4), (0,5), (1,2)
# (4,6), (5,5), (5,6), (4,5)


open my $input, "D:\\Perl\\input.txt" || die "Can't open file: $!\n";
 #open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";

my @list = (); 
	 
	while(<$input>){			
	chomp;	
	push @list,$_;
	}
close $input;


foreach(@list){
	
	
	 my @arr = $_=~ /\d+\,\d+/g;
	 # print Dumper \@arr;
	 print calc(\@arr);
}





sub calc{
	
my $arr_ref = shift;
my @koordinates = ();
my %hash = ();
foreach my $koord_pair(@$arr_ref){
	
	
	my ($x,$y) = split ",", $koord_pair;
	push @koordinates,[$x,$y];
	
	
}
# print Dumper \@koordinates;


for(my $i = 0; $i < $#koordinates; $i++){
	
	for(my $j = $i+1; $j <= $#koordinates; $j++){
	
	
		my $arr_ref1 = $koordinates[$i];
		my $arr_ref2 = $koordinates[$j];
		
		my $distance = sqrt(($arr_ref1->[0] - $arr_ref2->[0])**2 + ($arr_ref1->[1] - $arr_ref2->[1])**2);
		$hash{$distance}++;
	
	}	
}


my @res = grep {$_ == 4 || $_== 2} values %hash;

 return "true\n" if (scalar @res == 2);
 return "false\n";


}
 
 
 
 
 
 
 
 
 
 
my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";