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
	    push @list,$_;
	}
close $input;

#print Dumper \@list;
my $primes = Esieve(2,190);

foreach my $d (@list){

   print calc($d),"\n";
}

sub calc {
    my	( $d )	= @_;

    return 0 unless ( $d % 2 == 0 );
    my @digits = ();
    my $allPrimes = 0;
    my $allPrimes1 = 0;

    for ( my $i = 1; $i <= $d; $i++ ) {

        push @digits,$i;
    }
    $allPrimes = arePrimes( \@digits );

    if ( scalar @digits > 2 ){

        my @digits1 = @digits;
        push ( @digits1 , shift @digits1 );
        @digits1 = reverse @digits1;
        $allPrimes1 = arePrimes( \@digits1 );
        print join " ",@digits1,"\n";

    }
    print "*************************\n";
    print join " ",@digits,"\n";

    my $result = $allPrimes + $allPrimes1;
    return $result;

} ## --- end sub calc


sub arePrimes {
    my	( $arr )	= @_;

    my $allPrimes = 1;
    for ( my $i=0; $i < $#{$arr}; $i++ ) {

        my $temp = $arr->[$i] + $arr->[$i+1];
        unless ( defined $primes->{$temp} ){

            $allPrimes = 0;
            last;
        }
    }
    return $allPrimes;
} ## --- end sub arePrimes




sub Esieve {
    my	( $lowerLimit,$upperLimit )	= @_;

    my $sieveBond = int( ($upperLimit - 1)/2 );
    my $upperSqrt = int( (sqrt($upperLimit)-1)/2 );
    my @primeBits = ();
    my %numbers = ();

    for ( my $i = 0; $i <= $sieveBond; $i++ ) {
        $primeBits[$i] = 1;
    }

    for ( my $i=1;$i <= $upperSqrt; $i++ ) {

        if ( $primeBits[$i] ){

            for ( my $j = $i*2*($i+1);$j <= $sieveBond; $j+= 2* $i+1) {

                $primeBits[$j] = 0;
            }
        }
    }

    if ( $lowerLimit < 3 ){

        $numbers{2} = 1;
        $lowerLimit = 3;
    }

    for ( my $i = int($lowerLimit/2); $i <= $sieveBond; $i++ ) {

        if ( $primeBits[$i] ){

            my $temp = 2*$i +1;
            $numbers{$temp}++;
        }
    }
    return \%numbers;
} ## --- end sub Esieve

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
