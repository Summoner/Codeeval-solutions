#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper;
use Benchmark;

my $t0 = new Benchmark;

  open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
 #open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";



	while(<$input>){
    	chomp;
	    my( $n,$k,$a,$b,$c,$r ) = split /,/,$_;
        calc( $n,$k,$a,$b,$c,$r );
	}
close $input;


sub calc {
    my	( $n,$k,$a,$b,$c,$r )	= @_;

    my @m = ();

    $m[0] = $a;


    foreach my $i ( 1..($k -1) ) {

        $m[$i] = ( $b * $m[$i-1] + $c ) % $r;
    }

    my $index = $k;

    while( scalar @m < $n ){


        for ( my $i=0;$i <= $k ;$i++  ) {

          unless ( is_contain( \@m,$k,$i ) ){

            $m[$index] = $i;
            $index++;
            last;
          }
       }
    }
    print "$m[-1]\n";
} ## --- end sub calc


sub is_contain {
    my	( $m,$k, $val )	= @_;

    my $contain = 0;


    for ( my $i = scalar @$m - $k; $i < scalar @$m; $i++ ) {

        if ( $m->[$i] == $val ){

            $contain  = 1;
            last;
        }
    }

    return $contain;

} ## --- end sub is_contain
my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
