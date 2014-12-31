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

foreach my $number ( @list ) {

   print calc( $number ),"\n";
}

sub calc {
    my	( $number )	= @_;

    my @numbers = split //,$number;
    my $expr_count = 3 **( scalar @numbers-1 );

    my $count = 0;
    while ( $expr_count--){

        $count++ if ( is_ugly( $expr_count,\@numbers ) );
    }

    return $count;
} ## --- end sub calc

sub is_ugly {
    my	( $expr_count,$numbers )	= @_;

    my $result = 0;
    my $current = $numbers->[0];
    my $plus = 1;

    for ( my $i=1;$i < scalar (@$numbers); $i++, $expr_count = int($expr_count / 3) ) {

        if ( $expr_count % 3 ){

            if ( $plus ){

                $result += $current;

            }else{

                $result -= $current;
            }

            $current = $numbers->[$i];
            if ( $expr_count % 3 == 1 ){

                $plus = 1;

            }else{

                $plus = 0;
            }

        }else{

            $current = $current * 10 + $numbers->[$i];
        }
    }
    if ( $plus ){

        $result += $current;
    }else{

        $result -= $current;
    }

    return 1 if ( ($result % 2 == 0) || ($result % 3 == 0) || ($result % 5 == 0) || ($result % 7 == 0) );
    return 0;
} ## --- end sub is_ugly


my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
