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
	push @list, [split /\s+/,$_];
}
close $input;

my $magicNumbers = {};
createMagicNumbers($magicNumbers);
#print Dumper \$magicNumbers;
foreach my $arr (@list){
    print calc( $magicNumbers,$arr->[0],$arr->[1] ),"\n";
}

sub calc {
    my	( $magicNumbers,$first,$last )	= @_;
#$DB::single = 2;
    my @numbers = ();
    foreach my $number ( $first..$last ) {
        push @numbers,$number if ( exists $magicNumbers->{$number} );
    }
    if ( scalar @numbers > 0 ){
        return join " ",@numbers;
    }else{
        return -1;
    }
} ## --- end sub calc

sub createMagicNumbers {
    my	( $magicNumbers )	= @_;

    foreach my $digit ( 1..10000 ) {
        $magicNumbers->{$digit} = 1 if ( isMagicNumber($digit) );
    }
} ## --- end sub createMagicNumbers

sub isMagicNumber {
    my	( $n )	= @_;
    my @digits = split //,$n;
    my %uniq = ();
    grep{ $uniq{$_}++ }@digits;

    return 0 if ( scalar @digits != keys %uniq );

    my %visited = ();
    my $first = $digits[0];
    my $last = $digits[0];
    my $i = 0;

    while ( !defined $visited{$last} ){
        $visited{$last} = 1;
        $i = ( $i + $last ) % scalar @digits;
        $last = $digits[$i];
    }
    return $first == $last && scalar @digits == keys %visited;
} ## --- end sub isMagicNumber

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
