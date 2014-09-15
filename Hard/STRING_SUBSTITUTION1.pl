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
    my @replacement = ();
    my @F = ();
    my @R = ();
    my $k = 0;


foreach my $arr_ref (@list) {
    # my @digits = split //,$arr_ref->[0];
     @replacement = split /,/,$arr_ref->[1];
     @F = ();
     @R = ();
     $k = 0;
    for ( my $i = 0;$i < scalar @replacement; $i+=2) {
    
        $F[$k] = $replacement[$i];
        $R[$k] = $replacement[$i+1];
        $k++;
    }

    print find_final_string($arr_ref->[0]);
}



sub find_final_string {
    my	( $s )	= @_;
    my @strArray = split //,$s;
    
   my $finalString = "";
    for ( my $i=0;$i < scalar @F;$i++) {

        my  @FArray = split //,$F[$i];
         $finalString = "";
        
        my $j = 0;
        my $k = 0;

        my $m = 0;

        while($j < scalar @FArray && $k < scalar @strArray){

            if ($FArray[$j] eq $strArray[$k]){

                if ($j==0){
                    $m = $k;
                }
                $j++;
                $k++;
            }else{
                if ($j==0){
                    $m = $k;
                }
                $j=0;
                $k = $m+1;
            }
            
            if ($j == scalar @FArray){

                $strArray[$m] = "R".$R[$i];

                for ( my $k=1; $k < scalar @FArray;$k++) {
                    $strArray[$k + $m] = "R";
                }
                $j = 0;
                $k = $m + scalar @FArray;
            }

        }
    }
    
    for ( my $i=0;$i < scalar @strArray;$i++) {
        $strArray[$i] =~  s/R//;
        $finalString = $finalString . $strArray[$i];
    }
    return $finalString;
} ## --- end sub find_final_string
