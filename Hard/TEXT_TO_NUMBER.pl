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
	push @list,[split / /,$_];
	}
close $input;



my %values = (

negative => "-" ,
zero =>"0",
one => "1",
two =>"2",
three =>"3",
four => "4",
five => "5",
six => "6",
seven => "7",
eight => "8",
nine => "9",
ten => "10",
eleven => "11",
twelve =>"12",
thirteen =>"13",
fourteen => "14",
fifteen =>"15",
sixteen =>"16",
seventeen =>,"17",
eighteen => "18",
nineteen => "19",
twenty =>"20",
thirty =>"30",
forty =>"40",
fifty =>"50",
sixty =>"60",
seventy=>"70",
eighty=>"80",
ninety =>"90",
hundred => "100",
thousand => "1000",
million => "1000000"
);
 
foreach(@list){
	
	my $negative = 1;
	
	if($_->[0] eq "negative"){
		
		$negative = -1;		
		shift @$_;		
	}
	
	my $result = calc($_,0);
	
	print $result * $negative,"\n";
}




sub calc{
	
	my ($arr_ref,$result) = @_;	
	
	return "$result\n" if (scalar @$arr_ref == 0);
	my $partly_result = 0;
	
	foreach(0..$#{$arr_ref}){			
		
		if($arr_ref->[$_]  eq "million"){
			
			$partly_result *= 1000000;	
			splice @$arr_ref,0,$_+1;
			last;	
			
		}elsif($arr_ref->[$_] eq "thousand"){
			
			$partly_result *= 1000;
			splice @$arr_ref,0,$_+1;
			last;
			
		}elsif($arr_ref->[$_] eq "hundred"){
			
			
			$partly_result *= 100;
			 
		}else{
			
			$partly_result += $values{$arr_ref->[$_]};	
			if($_ == $#{$arr_ref}){
				
			@$arr_ref = ();	
			}	
		}				
	}	
	$result += $partly_result;
	calc($arr_ref,$result);	
}
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";