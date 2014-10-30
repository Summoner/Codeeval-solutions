#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper; 
use Benchmark;

my $t0 = new Benchmark;

  open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
 #open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";

my @list = (); 
	 
	while(<$input>){
    	chomp;	
	    push @list,$_;
	}
close $input;



foreach my $digit ( @list ) {

    print deep( $digit ) ,"Dollars\n";
}



sub deep {
    my	( $number )	= @_;

    if ($number < 20){
    
        my $index = $number;
        my @words = ( "Zero","One","Two","Three","Four","Five","Six","Seven","Eight","Nine","Ten","Eleven","Twelve","Thirteen","Fourteen","Fifteen","Sixteen",
                      "Seventeen","Eighteen","Nineteen");
        return $words[$index];

    }elsif( $number < 100 ){
    
        my $index = ( int($number /10) ) - 2;
        my @words = ( "Twenty","Thirty","Forty","Fifty","Sixty","Seventy","Eighty","Ninety" );
        my $part = ($number % 10 == 0) ? "": deep( $number % 10);
        return $words[$index] . $part;

    }elsif( $number < 1000 ){
    
        my $index = int($number /100);
        my $part = ($number % 100 == 0) ? "": deep( $number % 100);
        return deep( $index ) . "Hundred" . $part;

    }else{

        my $temp = log10($number);

        my $index = int( $temp );
        my @words = ( "Thousand","Million" );
        
        my $str1 = substr $number,0, ($index % 3) + 1;
        my $first_part = deep( $str1 ) . $words[ int($index / 3)-1 ];

        my $str2 = substr $number,($index % 3) +1;
        my $last_part = $number % 10 ** $index > 0 ? deep( $str2) : "";

      
        return $first_part . $last_part;
    }



    return ;
} ## --- end sub deep


sub log10 {
    my	( $n )	= @_;
    return 3 if ($n == 1000);

    my $res = log($n)/log(10);
    return $res;
} ## --- end sub log10


my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
