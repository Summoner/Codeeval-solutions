#!/usr/bin/perl -d
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
	push @list,[split /,/,$_];
	}
close $input;

#print Dumper \@list;

foreach my $str (@list){

   print calc($str),"\n";
}



sub calc {
    my	( $str,$c )	= @_;

    my $l = 0;
     print defined($c) ? $c:"undef","<--------->", join " ",@$str,"\n";
 
    for ( my $i=0;$i <= $#{$str} ;$i++  ) {
        my @next_str = ();
        if (!defined($c) || $c eq get_first($str->[$i])){
         
                       
            for ( my $j=0;$j <= $#{$str} ;$j++  ) {
                 next if ($i == $j);
                 push @next_str,$str->[$j];
            }
        }else{
            next;
        }
        
        $l = max($l,calc(\@next_str,get_last($str->[$i])));

    }

    if ( defined($c) ){
        
        return $l+1;    

    }elsif( $l >1 ){

        return $l;

    }else{
    
    return "None";
    }
} ## --- end sub calc

sub max {
    my	( $par1,$par2 )	= @_;
    return $par1 if ($par1 > $par2);
    return $par2;
} ## --- end sub max

sub get_first {
    my	( $str )	= @_;

    return substr($str, 0,1) ;
} ## --- end sub get_first

sub get_last {
    my	( $str )	= @_;

    return substr ($str,-1);
} ## --- end sub get_last


my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
