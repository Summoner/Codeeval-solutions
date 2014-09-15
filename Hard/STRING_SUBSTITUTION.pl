#!/usr/bin/env perl -w
use strict;
use warnings;
use utf8;
use Data::Dumper; 

open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
# open my $result, ">D:\\Perl\\output.txt" || die "Can't open file: $!\n";

my @list = ();

while(<$input>){
	
	chomp;
	push @list,[split /;/,$_];
	
}
close $input;
    
foreach my $arr_ref (@list) {

    print find_final_string($arr_ref->[0],$arr_ref->[1]);
}



sub find_final_string {
    my	( $string,$replacement )	= @_;
    
    my @replacements = split /,/,$replacement;

    my $finalString = "";


    my %hash = ();
    $hash{1} = "a";
    $hash{0} = "b";

    my %rhash = reverse %hash;

    
    for ( my $i = 0;$i < scalar @replacements;$i+=2) {
       my $inp =  $replacements[$i];
       my @repl = split //,$replacements[$i+1];
       my $repl = "";


       foreach (@repl) {
           $repl .= $hash{$_};
       }
        $string =~ s/$inp/$repl/g;
       
    }

    my @str_array = split //,$string;
    

    foreach  (@str_array) {

        if (defined $rhash{$_}){

            $finalString .= $rhash{$_};

        }else{
            $finalString .= $_;
        }
    }



    return $finalString;
} ## --- end sub find_final_string
