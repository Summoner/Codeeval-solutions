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
#print Dumper \@arr;
my $count = 0;
my $index = 0;
my $weight = 0;
my $value = 0;
my $items = [];
foreach my $arr_ref(@arr) {
    
    my $W = shift @$arr_ref;
    $items = [];

    foreach (@$arr_ref){
                
        $count++;
        if ( $count == 1 ){
        
             $index = $_;

        }elsif( $count == 2 ){
        
            $weight = $_ * 100;

        }elsif ( $count == 3 ){
            
                $value = $_;
                my $item = {};
                $item->{index} = $index;
                $item->{weight} = $weight;
                $item->{value} = $value;
                push @$items, $item;
                $count = 0;
         }
    }

    unshift @$items,0;
    pack1($W,$items);
}



sub pack1 {
    my	( $W,$items )	= @_;

    my $A = [];
    my $B = [];


    for ( my $i=0;$i<= $W;$i++ ) {

        $A->[0]->[$i] = 0;
        $B->[0]->[$i] = 0;
    }

    for ( my $i=0;$i< scalar @$items;$i++ ) {

        $A->[$i]->[0] = 0;
        $B->[$i]->[0] = 0;
    }

   

    for ( my $i=1; $i < scalar @$items; $i++) {

        for ( my $j=1; $j <= $W; $j++ ) {

           if ( $items->[$i]->{weight} > $j ){

                $A->[$i]->[$j] = $A->[$i-1]->[$j];
                $B->[$i]->[$j] = 0;

           }elsif( $items->[$i]->{weight} <= $j ){
           
                if ( ( $items->[$i]->{value} + $A->[$i-1]->[$j - $items->[$i]->{weight}] ) > $A->[$i-1]->[$j] ){
                    
                    $A->[$i]->[$j] =  $items->[$i]->{value} + $A->[$i-1]->[$j - $items->[$i]->{weight}];   
                    $B->[$i]->[$j] = 1;

                }else{
                
                     $A->[$i]->[$j] =  $A->[$i-1]->[$j];
                     $B->[$i]->[$j] = 0;

                }
           }
    }
}
    

    my @result = ();

    get_indexes($#{$B},$#{$B->[-1]},\@result,$B,$items);

    if (scalar @result > 0){

        print join (",", sort{$a<=>$b}@result),"\n";
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

sub show_arr {
    my	( $arr )	= @_;


    for ( my $i=0;$i <= $#{$arr};$i++ ) {


        for ( my $j=0;$j <= $#{$arr->[$i]} ;$j++ ) {

                print "$arr->[$i]->[$j]\t";
        }
        print "\n";
    }
    return ;
} ## --- end sub show_arri


sub max {
    my	( $a,$b )	= @_;

    return $a if ( $a > $b ) ;
    return $b;
} ## --- end sub max
