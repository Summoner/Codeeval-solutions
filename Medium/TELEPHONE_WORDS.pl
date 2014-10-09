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
	push @list,[split //,$_];
	}
close $input;
my $values = [
         [0],
         [1],
         ["a","b","c"],
         ["d","e","f"],
         ["g","h","i"],
         ["j","k","l"],
         ["m","n","o"],
         ["p","q","r","s"],
         ["t","u","v"],
         ["w","x","y","z"]
     ];



foreach my $digits ( @list ) {
   print join (",", sort{$a cmp $b} deep(@$digits)),"\n";
}

  

sub deep{

    my (@digits) = @_;
    my @temp = ();
    return [] if (scalar @digits == 0);
    
    my @letters = @{$values->[$digits[0]]};

    return @letters if (scalar @digits == 1);

    shift @digits;


    foreach my $i (0..$#letters) {

        my @sub_letters = deep(@digits);

        foreach my $j (0..$#sub_letters ) {
        
            $sub_letters[$j] = $letters[$i] . $sub_letters[$j];

        }

        push @temp,@sub_letters;
    }
  return @temp;  
}








