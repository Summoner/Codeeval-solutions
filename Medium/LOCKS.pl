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

#print Dumper \@list;

foreach my $str (@list){
    print calc($str->[0],$str->[1]),"\n";
}


sub calc {
    my	( $N,$M )	= @_;

    my @doors = ();


    for ( my $i=0;$i < $N ;$i++ ) {

        $doors[$i] = 0;
    }


    for ( my $i=1; $i < $M ; $i++ ) {

        iter(\@doors);
    }
    
     if ( $doors[-1] == 1){
       
            $doors[-1] =0;

     }else{
            
            $doors[-1] = 1;
     }

     my %doors_states = ();



     foreach my $door_state ( @doors ) {

         $doors_states{$door_state}++;
     }

    return $doors_states{0};
} ## --- end sub calc


sub iter {
    my	( $arr )	= @_;

    
    for ( my $i=1;$i <= $#{$arr} ;$i+=2 ) {

        $arr->[$i] = 1;    
    }

    for ( my $i=2;$i <= $#{$arr} ;$i+=3 ) {

       if ( $arr->[$i] == 1){
       
            $arr->[$i] =0;

       }else{
            
            $arr->[$i] = 1;
       }    
    }
   
} ## --- end sub iter

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
