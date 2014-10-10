#!/usr/bin/perl -w
use strict;
use warnings;
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

    my @word1 = split //,$arr_ref->[0];
    my @word2 = split //,$arr_ref->[1];
    
    unshift @word1,0; 
    unshift @word2,0;
    my $res = [];
    my $arr =  get_arr(\@word2,\@word1);
    get_common($arr,\@word2,\@word1,$#{$arr},$#{$arr->[0]},$res);
    print join "",@$res,"\n";
}



sub get_common {
    my	( $arr,$word1,$word2,$i,$j,$res )	= @_;

    return $res if ($arr->[$i]->[$j] == 0);

    if ($arr->[$i]->[$j] == $arr->[$i-1]->[$j]){

        get_common($arr,$word1,$word2,$i-1,$j,$res);

    }elsif ($arr->[$i]->[$j] == $arr->[$i]->[$j-1]){
        
        get_common($arr,$word1,$word2,$i,$j-1,$res);

    }else{
        
         unshift  @$res,$word1->[$i];
        # print $word1->[$i];
        get_common($arr,$word1,$word2,$i-1,$j-1,$res);
    }
}

sub get_arr{

    my $word1 = shift;
    my $word2 = shift;
    my $arr = [];

    for ( my $i = 0;$i < scalar @$word2;$i++) {
                
            $arr->[0]->[$i] = 0;
     }


    for ( my $i = 0;$i < scalar @$word1;$i++) {
          
            $arr->[$i]->[0] = 0;
    }


     for ( my $i = 1;$i < scalar @$word1;$i++) {
        
        for ( my $j = 1;$j < scalar @$word2;$j++) {
           

                if ($word1->[$i] eq $word2->[$j]){

                    $arr->[$i]->[$j] =  $arr->[$i-1]->[$j-1]+1;
                 }else{
         
                     $arr->[$i]->[$j] = max($arr->[$i]->[$j-1],$arr->[$i-1]->[$j]);
                 }
         }
     }

return $arr;
}

sub max {
    my	( $x,$y )	= @_;
    return $x if ($x > $y);
    return $y;
} ## --- end sub max



