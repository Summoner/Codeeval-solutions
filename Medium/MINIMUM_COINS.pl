#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper; 
use Benchmark;

my $t0 = new Benchmark;

open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
# open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";


my @list = ();

 while(<$input>){
	
	 chomp;
	 push @list, $_;
	
  }
 close $input;


  foreach (@list){
	
	 print deep($_,0),"\n";
	
  }




sub deep{
	
	my ( $value, $count ) = @_;

    return $count if ($value == 0);
	
	if ($value >= 5){
		
		$count++;
		my $value = $value-5;			
		deep($value,$count);
			
	}elsif($value >= 3){
		
		$count++;
		my $value = $value-3;			
		deep($value,$count);


	}elsif($value >= 1){
		
		$count++;
		my $value = $value-1;			
		deep($value,$count);
		
	}
}



my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
