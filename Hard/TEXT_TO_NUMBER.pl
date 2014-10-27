#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper; 
use Benchmark;

my $t0 = new Benchmark;

  open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
 #open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";

my @list = (); 
	 
	while(<$input>){
    	chomp;	
	    push @list,[split / /,$_];
	}
close $input;

# fifteen
# negative six hundred thirty eight
# zero
# two million one hundred seven

my %values = (

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
    ninety =>"90"
    );
 
foreach(@list){
	
	my $negative = 1;
	
	if($_->[0] eq "negative"){
		
		$negative = -1;		
		shift @$_;		
	}
	
	my $for_calc = [0];

    
    my $result = calc($_,$for_calc,0);
	print $result * $negative,"\n";
}




sub calc{
	
	my ($arr_ref,$for_calc,$result) = @_;	
	
    if (scalar @$arr_ref == 0){
    
        my $val = pop @$for_calc;
        $result += $val;
 	    return "$result\n";    
    }

	my $current_value = shift @$arr_ref;

    if ( exists $values{$current_value} ){
    
        my $val = pop @$for_calc;
        $val += $values{$current_value};
        push @$for_calc, $val;
        calc($arr_ref,$for_calc,$result);

    }elsif( $current_value eq "million" ){
    
        my $val = pop @$for_calc;
        $val *= 1000000;
        $result += $val;
        $for_calc = [0];
        calc($arr_ref,$for_calc,$result);
    
    }elsif( $current_value eq "thousand" ){
    
        my $val = pop @$for_calc;
        $val *= 1000;
        $result += $val;
        $for_calc = [0];
        calc($arr_ref,$for_calc,$result);

    }elsif( $current_value eq "hundred" ){
    
        my $val = pop @$for_calc;
        $val *= 100;
        push @$for_calc, $val;
        calc($arr_ref,$for_calc,$result);
    }
}
  
my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
