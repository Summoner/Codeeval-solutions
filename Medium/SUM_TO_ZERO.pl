#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper; 
use Benchmark;

my $t0 = new Benchmark;
open my $input, "D:\\Perl\\input.txt" || die "Can't open file: $!\n";
#open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";

my @list = ();

while(<$input>){
	
	chomp;
	push @list, [split /,/,$_];
	
}
close $input;



foreach my $arr_ref(@list){	
	
	my $indexes_ref = get_next(scalar @$arr_ref);	
	my $count = calc($indexes_ref,$arr_ref);
	print $count,"\n";
	
}


sub calc{
	
my ($indexes_ref,$val_ref) = @_;
my $count = 0;

for(my $i = 0; $i <= $#{$indexes_ref}; $i++){
	
	my $summ = 0;
	 
	for(my $j = 0; $j <= $#{$indexes_ref->[$i]}; $j++){
	
		$summ += $val_ref->[$indexes_ref->[$i]->[$j]];		 	
	}
	
	
	 
	if ($summ == 0){
		
		$count++ ;	 
	}
}		
	return $count;	
}





sub get_next{

my $count = shift;

my @comb = (0,1,2,3);

my $result_ref;

 
while(1){
 	
 	 last if (scalar @comb == 0);
 	 push @$result_ref,[@comb];
 	 GetNextCombination($count,4,\@comb); 	
 }
 
 return $result_ref;
 
 }
 sub GetNextCombination{
	
	
	my $n = shift;
	my $k = shift;	
	my $comb_ref = shift;	
	my $i = $k - 1;
	
	++$comb_ref->[$i];
	
	while(($i > 0) && ($comb_ref->[$i] >= $n - $k + 1 + $i)){
		
		--$i;
		++$comb_ref->[$i];		
	}
	
	if ($comb_ref->[0] > $n - $k){
		
		return @$comb_ref = ();		
	}
	
	for ($i = $i +1; $i < $k; ++$i){
		
		$comb_ref->[$i] = $comb_ref->[$i - 1] + 1;		
	}	
}

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";