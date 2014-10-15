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

my $max_encoded_value = 26;

foreach (@list){	
	
    my $arr = [split //,$_];
    print calc($arr),"\n";	
}


sub calc{

    my ($arr) = shift;
    
    return 1 if (scalar @$arr == 0 || scalar @$arr == 1);

    my $possibilities = 0;
    my $num_chars = 1;
    
    while(1){
    
        my $chars = [];


        foreach my $index ( 0..$#{$arr}  ) {
        
            last if ($index >= $num_chars);
            push @$chars, $arr->[$index];

        }

        last if (scalar @$chars != $num_chars);
        my $encoded_value = join "", @$chars;

        last if ($encoded_value > $max_encoded_value);

        my $next_arr = [];

        
        foreach my $index ( $num_chars..$#{$arr}  ) {

            push @$next_arr, $arr->[$index];
        }

        $possibilities += calc($next_arr);

        $num_chars++;
    
    }

return $possibilities;

}

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
