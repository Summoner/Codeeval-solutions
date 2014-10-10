#!/usr/bin/perl -w

use strict;
use warnings;
use Data::Dumper; 


open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
#open my $output, ">/home/fanatic/Summoner/Codeeval-solutions/output.txt" || die "Can't open file: $!\n";


my @list = ();

while(<$input>){
	
	chomp;
	push @list, [split /:/,$_];
	
}
close $input;

my @arr = ();
foreach my $arr_ref (@list ) {

    $arr_ref->[1] =~ s/\s+\(//g;
    $arr_ref->[1] =~ s/\)/,/g;
    $arr_ref->[1] =~ s/\$//g;
    my $max_cap = $arr_ref->[0] * 100;
    my $str = join ",",$max_cap,$arr_ref->[1];
    push @arr,[split /,/,$str]; 
}

my $count = 0;
my $key = 0;
my $weight = 0;
my $value = 0;
my $parts = [];
foreach my $arr_ref(@arr) {
    

    my $W = shift @$arr_ref;
    
       $parts = [];
    foreach (@$arr_ref){
                
        $count++;

        $key = $_ if ($count == 1);
        $weight = $_ * 100 if ($count == 2);
         if ($count == 3){
            
                $value = $_;
                my $hash = {};
                $hash->{index} = $key;
                $hash->{weight} = $weight;
                $hash->{value} = $value;
                push @$parts, $hash;
                $count = 0;
         }
    }

 unshift @$parts,0;
 pack1($W,$parts);

}



sub pack1 {
    my	( $W,$parts )	= @_;

    my $A = [];
    my $B = [];


    for ( my $i=0;$i<= $W;$i++ ) {

        $A->[0]->[$i] = 0;
    }

    for ( my $i=0;$i< scalar @$parts;$i++ ) {

        $A->[$i]->[0] = 0;
    }
    for ( my $i=1;$i<= $W;$i++ ) {

        $B->[0]->[$i] = 0;
    }
    for ( my $i=1; $i < scalar @$parts; $i++) {

        for ( my $j=1;$j <= $W;$j++) {

           if ($parts->[$i]->{weight} > $j){

                $A->[$i]->[$j] = 0;
                $B->[$i]->[$j] = 0;

           }elsif($parts->[$i]->{weight} <= $j){
           
                if ( $parts->[$i]->{value} + $A->[$i-1]->[$j - $parts->[$i]->{weight}] > $A->[$i-1]->[$j] ){
                    
                    $A->[$i]->[$j] =  $parts->[$i]->{value} + $A->[$i-1]->[$j - $parts->[$i]->{weight}];   
                    $B->[$i]->[$j] = 1;

                }else{
                
                     $A->[$i]->[$j] =  $A->[$i-1]->[$j];
                     $B->[$i]->[$j] = 0;

                }
           }
    }
}
    

    my @result = ();

    get_indexes($#{$B},$#{$B->[-1]},\@result,$B,$parts);


    if (scalar @result > 0){

        print join (" ", sort{$a<=>$b}@result),"\n";
    }else{

        print "-\n";
    }
} ## --- end sub package

sub get_indexes {
    my	( $i,$j,$res,$B,$parts )	= @_;

    return $res if ($i == 0);

            if ($B->[$i]->[$j] == 1){
                
                push @$res,$parts->[$i]->{index};
                $j = $j - $parts->[$i]->{weight};
                $i = $i - 1;
                get_indexes($i,$j,$res,$B,$parts);

            }elsif($B->[$i]->[$j] == 0){
            
                $i = $i - 1;
                get_indexes($i,$j,$res,$B,$parts);

            }
} ## --- end sub get_indexes

