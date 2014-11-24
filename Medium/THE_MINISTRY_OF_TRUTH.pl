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
	push @list,[split /;/,$_];
	}
close $input;

#print Dumper \@list;


foreach my $arr ( @list ) {

   print  main( $arr ),"\n";
}

sub main {
    my	( $arr )	= @_;

    my @arr1 = split /\s+/,$arr->[0];
    my @arr2 = split /\s+/,$arr->[1];
    
    my @result = ();
    my $is_exist = 0;
    my $index = 0;

    foreach my $i (0..$#arr2 ) {

    if ( $index == scalar @arr1 ){
   
        @result = ();
        $is_exist = 0;
        last;    
    }

        foreach my $j ($index..$#arr1 ) {
        
            if ( is_substr( $arr1[$j],$arr2[$i] ) ){
            
               $is_exist = 1;
               push @result,form( $arr1[$j], $arr2[$i] );
               $index = $j+1;
               last;

            }else{
            
               push @result, ( "_" x length( $arr1[$j] )) ;            
            }

                        
        }
    }

    if ( $is_exist && ( scalar @arr1 != scalar @result) ){
    
        
        foreach ( scalar @result .. scalar @arr1-1 ) {

            push @result, "_" x length ( $arr1[$_] );
        }
    }
    push @result, "I cannot fix history" unless ( $is_exist );
    return join " ",@result;
} ## --- end sub main



sub form {
    my	( $str1,$str2 )	= @_;

    my @arr1 = ( ("_") ) x length($str1);

    my $start_pos = index( $str1,$str2 );

    my $position = 0;

    for ( my $i=$start_pos; $i < $start_pos + length($str2); $i++ ) {

        $arr1[$i] = substr( $str2, $position,1 );
        $position++;
    }
    return join "",@arr1;
} ## --- end sub form


sub is_substr {
    my	( $str,$substr )	= @_;

    return 1 if ( $str =~ /$substr/);
    return 0;
} ## --- end sub is_substr
my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n"
