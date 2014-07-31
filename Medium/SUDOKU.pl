#!/usr/bin/perl -d
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
	push @list, [split /;/,$_];
	
}
close $input;


foreach (@list){	
		 
	 my $length = $_->[0];
	 my @values = split /,/,$_->[1]; 
	 
	 my $matrix = [];
	 my $count = 0;
	 for (my $i = 0; $i < $length; $i++){
		
		for (my $j = 0; $j < $length; $j++){
		 
			$matrix->[$i]->[$j] = $values[$count];
			$count++;
	        }		
	 }
	  print Dumper \$matrix;
	 
	 print calc($matrix,$length);
}



sub calc{
	
	my ($matrix,$length) = @_;
	
	foreach(@$matrix){
		
		return "False\n" unless (check($_,$length));		
	}
	
	for (my $j = 0; $j < $length; $j++){
		
		my $arr = [];		
		
		for (my $i = 0; $i < $length; $i++){
		 
			push @$arr,$matrix->[$i]->[$j];
						 
		}	
		return "False\n" unless (check($arr,$length));			 
	}
	
	
	
	if($length == 4){		
		
		my $left_i = 0;		
		my $left_j = 0;
		
		my $right_i = sqrt($length);
		my $right_j = $right_i;
		
		my $part = $right_i;		 
		
		my $arr_ref = generate_sub_grids($left_i,$left_j,$right_i,$right_j,$matrix);
		return "False\n" unless (check($arr_ref,$length));		
		
		$left_j = $right_j;
		$right_j += $part;
		$arr_ref = generate_sub_grids($left_i,$left_j,$right_i,$right_j,$matrix);
		return "False\n" unless (check($arr_ref,$length));
		# $DB::single = 2;	 
		$left_j = 0;		
		$right_j = $part;
		$left_i = $right_i;
		$right_i += $part;		 
		$arr_ref = generate_sub_grids($left_i,$left_j,$right_i,$right_j,$matrix);
		return "False\n" unless (check($arr_ref,$length));	
		
		
		$left_j = $right_j;
		$right_j += $part;
		$arr_ref = generate_sub_grids($left_i,$left_j,$right_i,$right_j,$matrix);
		return "False\n" unless (check($arr_ref,$length));	
				 	
	}elsif($length == 9){		
		 		
		 # $DB::single = 2;	
		my $left_i = 0;		
		my $left_j = 0;
		
		my $right_i = sqrt($length);
		my $right_j = $right_i;
		
		my $part = $right_i;		 
		
		my $arr_ref = generate_sub_grids($left_i,$left_j,$right_i,$right_j,$matrix);
		 
		return "False\n" unless (check($arr_ref,$length));		
		
		$left_j = $right_j;
		$right_j += $part;
		$arr_ref = generate_sub_grids($left_i,$left_j,$right_i,$right_j,$matrix);
		
		return "False\n" unless (check($arr_ref,$length));
		
		$left_j = $right_j;
		$right_j += $part;
		$arr_ref = generate_sub_grids($left_i,$left_j,$right_i,$right_j,$matrix);
		 
		return "False\n" unless (check($arr_ref,$length));
		
		# $DB::single = 2;	 
		$left_j = 0;		
		$right_j = $part;
		$left_i = $right_i;
		$right_i += $part;		 
		$arr_ref = generate_sub_grids($left_i,$left_j,$right_i,$right_j,$matrix);
		 
		return "False\n" unless (check($arr_ref,$length));
		
		$left_j = $right_j;
		$right_j += $part;
		$arr_ref = generate_sub_grids($left_i,$left_j,$right_i,$right_j,$matrix);
		 
		return "False\n" unless (check($arr_ref,$length));
		
		$left_j = $right_j;
		$right_j += $part;
		$arr_ref = generate_sub_grids($left_i,$left_j,$right_i,$right_j,$matrix);
		 
		return "False\n" unless (check($arr_ref,$length));
		
		
		$left_j = 0;		
		$right_j = $part;
		$left_i = $right_i;
		$right_i += $part;		 
		$arr_ref = generate_sub_grids($left_i,$left_j,$right_i,$right_j,$matrix);
		 
		return "False\n" unless (check($arr_ref,$length));	
		
		
		$left_j = $right_j;
		$right_j += $part;
		$arr_ref = generate_sub_grids($left_i,$left_j,$right_i,$right_j,$matrix);
		 
		return "False\n" unless (check($arr_ref,$length));	
		
		$left_j = $right_j;
		$right_j += $part;
		$arr_ref = generate_sub_grids($left_i,$left_j,$right_i,$right_j,$matrix);
		 
		return "False\n" unless (check($arr_ref,$length));
				 	
	}	
	
	return "True\n";	
}

sub generate_sub_grids{
	
	my($left_i,$left_j,$right_i,$right_j,$matrix) = @_;
	my $arr = [];
	for (my $i = $left_i; $i < $right_i; $i++){
		
		for (my $j = $left_j; $j < $right_j; $j++){
		 
			push @$arr,$matrix->[$i]->[$j];			 
	        }		
	 }
	
	return $arr;
}


sub check{
	
	my($arr_ref, $n) = @_;
	
	my %hash = ();
	
	foreach(@$arr_ref){
		
		$hash{$_}++;		
	}	
	return 1 if (keys %hash == $n);
	return 0;	
}


my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";