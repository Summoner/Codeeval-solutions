#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper;
use Benchmark;

my $t0 = new Benchmark;
open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
# open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";

    my @list = ();
	while( <$input> ){

        chomp;
        push @list, $_;
    }
close $input;

foreach my $number ( @list ) {

    print is_happy($number),"\n";
}




sub is_happy {
    my	( $number )	= @_;

    my $cash = {};
    $cash->{$number}++;

    while ( $number != 1 ){

        $number = next_number( $number );
        last if ( exists $cash->{$number} );
        $cash->{$number}++;
    }
    return 1 if ( $number == 1);
    return 0;
} ## --- end sub is_happy


sub next_number {
    my	( $number )	= @_;

    my @digits = split //,$number;
    my $result = 0;

    foreach my $digit ( @digits ) {

        $result += $digit * $digit;
    }
    return $result;
} ## --- end sub next_number

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
