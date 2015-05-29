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

foreach my $arr ( @list ) {
    if ( isArmstrongNumber( $arr ) ){
        print "True\n";
    }else{
        print "False\n";
    }
}

sub isArmstrongNumber {
    my	( $arr )	= @_;
    my $pow = scalar @$arr;
    my $number = join "",@$arr;
    my $sum = 0;

    foreach my $digit ( @$arr ) {
        $sum += $digit ** $pow;
    }

    return 1 if ( $sum == $number );
    return 0;
} ## --- end sub isArmstrongNumber

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
