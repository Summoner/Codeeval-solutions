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

my %roman = (

I => 1,
V => 5,
X => 10,
L => 50,
C => 100,
D => 500,
M => 1000
);


#print Dumper \@list;

foreach my $str (@list){

   print  calc1($str),"\n";

}


sub calc1 {
    my	( $arr )	= @_;
  my $total = 0; 
    for ( my $i=0;$i <= $#{$arr} ;$i++  ) {


    next unless (exists $roman{$arr->[$i]} );
    if ($i == $#{$arr}){
    
         $total += $arr->[$i-1] * $roman{$arr->[$i]}; 
         last;
    }
         
            if ( $roman{$arr->[$i]} < $roman{$arr->[$i + 2]} ){
                
                $total -= $arr->[$i-1] * $roman{$arr->[$i]};

            }else{

                $total += $arr->[$i-1] * $roman{$arr->[$i]};
            }
   }

   return $total;
} ## --- end sub calc1


sub calc {
    my	( $arr )	= @_;


    my $total = 0;
    for ( my $i=0;$i <= $#{$arr} ;$i++ ) {

        if ( exists $roman{$arr->[$i]} && $i < $#{$arr} ){
        
            if ( $roman{$arr->[$i]} < $roman{$arr->[$i + 2]} ){
                
                $total -= $arr->[$i-1] * $roman{$arr->[$i]};

            }else{

                $total += $arr->[$i-1] * $roman{$arr->[$i]};
            }        
        }else{
        
          $total += $arr->[$i-1] * $roman{$arr->[$i]};
                 
        }
    }


    return $total;
} ## --- end sub calc

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
