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

my $count = 0;
my $matrix = [];
foreach my $elem ( @list ) {

    if ( $count == 0 ){

        unless ( scalar @$matrix == 0 ){

            calc( $matrix );
            print "$matrix->[0]->[0]\n";
        }

        $matrix = [];
        $count = $elem;
        next;
    }else{

        push @$matrix,[split /,/,$elem];
        $count--;
    }
}
 calc( $matrix );
 print "$matrix->[0]->[0]\n";


sub calc {
    my	( $matrix )	= @_;


    for ( my $i= $#{$matrix} - 1; $i >= 0 ; $i-- ) {

        $matrix->[$#{$matrix}]->[$i] +=  $matrix->[$#{$matrix}]->[$i+1];
        $matrix->[$i]->[$#{$matrix->[$i]}] += $matrix->[$i+1]->[$#{$matrix->[$i]}];
    }


    for ( my $i = $#{$matrix} - 1;$i >= 0; $i--) {

        for ( my $j = $#{$matrix->[$i]}-1; $j>= 0 ;$j--) {

            $matrix->[$i]->[$j] += min($matrix->[$i+1]->[$j],$matrix->[$i]->[$j+1]);
        }
    }
} ## --- end sub calc



sub min {
    my	( $n1,$n2 )	= @_;

    return $n1 if ( $n1 < $n2);
    return $n2;
} ## --- end sub max

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
