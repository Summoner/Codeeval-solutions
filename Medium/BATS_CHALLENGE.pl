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
	push @list,[split /\s+/,$_];
	}
close $input;

foreach my $arr_ref (@list){
       
  print get_max($arr_ref), "\n";
}


sub get_max {
    my	( $arr )	= @_;
    my $I = shift @$arr;
    my $d = shift @$arr;
    my $n = shift @$arr;
    my $c = 0;

    
    if ($n != 0){

        my $temp = [];
        my $i = 1;

        while ($i <= $#{$arr}){
    
            push @$temp,[$arr->[$i-1],$arr->[$i]];
            $i++;
        }
    
        foreach my $arr1 ( @$temp ) {

            $c += int (($arr1->[1] - $arr1->[0]) / $d -1);
        }

        $c += int (($arr->[0] - 6) / $d);
        $c += int (($I - 6 - $arr->[-1]) / $d);
    }else{
    
        $c = int (($I - 12) / $d +1);
    }
    return $c ;
} ## --- end sub get_max

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
