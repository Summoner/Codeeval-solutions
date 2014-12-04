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
    pack2($W,$items);
}



sub pack2 {
    my	( $capacity,$items )	= @_;

    my $values = [];
    my $weights = [];
    my $indexes = [];


    for ( my $i=0; $i<= $capacity; $i++ ) {

        $weights->[0]->[$i] = 0;
        $values->[0]->[$i] = 0;
        $indexes->[0]->[$i] = 0;
    }

    for ( my $i=0;$i< scalar @$items;$i++ ) {

        $weights->[$i]->[0] = 0;
        $values->[$i]->[0] = 0;
        $indexes->[$i]->[0] = 0;
    }

   

    for ( my $i=1; $i < scalar @$items; $i++) {

        for ( my $j=1; $j <= $capacity; $j++ ) {

           if ( $items->[$i]->{weight} > $j ){

                $values->[$i]->[$j] = $values->[$i-1]->[$j];
                $weights->[$i]->[$j] = $weights->[$i-1]->[$j];
                $indexes->[$i]->[$j] = 0;

           }elsif( $items->[$i]->{weight} <= $j ){
           
                if ( ( $items->[$i]->{value} + $values->[$i-1]->[$j - $items->[$i]->{weight}] ) > $values->[$i-1]->[$j] ){
                    
                       $values->[$i]->[$j] =  $items->[$i]->{value} + $values->[$i-1]->[$j - $items->[$i]->{weight}];
                       $weights->[$i]->[$j] =  $items->[$i]->{weight} + $weights->[$i-1]->[$j - $items->[$i]->{weight}];
                       $indexes->[$i]->[$j] = 1;

                }elsif ( ( $items->[$i]->{value} + $values->[$i-1]->[$j - $items->[$i]->{weight}] ) == $values->[$i-1]->[$j] ){
                
                    if ( ( $items->[$i]->{weight} + $weights->[$i-1]->[$j - $items->[$i]->{weight}] ) <  $weights->[$i-1]->[$j] ){
                        
                       $values->[$i]->[$j] =  $items->[$i]->{value} + $values->[$i-1]->[$j - $items->[$i]->{weight}];
                       $weights->[$i]->[$j] =  $items->[$i]->{weight} + $weights->[$i-1]->[$j - $items->[$i]->{weight}];
                       $indexes->[$i]->[$j] = 1; 

                    }else{

                        $values->[$i]->[$j] =  $values->[$i-1]->[$j];
                        $weights->[$i]->[$j] =  $weights->[$i-1]->[$j];
                        $indexes->[$i]->[$j] = 0;
                    }

                }elsif( ( $items->[$i]->{value} + $values->[$i-1]->[$j - $items->[$i]->{weight}] ) < $values->[$i-1]->[$j] ){
                
                     $values->[$i]->[$j] =  $values->[$i-1]->[$j];
                     $weights->[$i]->[$j] =  $weights->[$i-1]->[$j];
                     $indexes->[$i]->[$j] = 0;
 
                }
           }
    }
}
    

    my @result = ();

    get_indexes($#{$indexes},$#{$indexes->[-1]},\@result,$indexes,$items);

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

