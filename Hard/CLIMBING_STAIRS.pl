#!/usr/bin/env perl -w
use strict;
use warnings;
use utf8;
use Data::Dumper;
use bigint;

open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
# open my $result, ">D:\\Perl\\output.txt" || die "Can't open file: $!\n";

my @list = ();

while(<$input>){

	chomp;
	push @list,$_;

}
close $input;

my %cashe = ();

foreach my $elem (@list) {

    print calc($elem),"\n";
}




sub calc {
    my	( $n )	= @_;

    return 0 if ( $n == 0 );
    my $a = 1;
    my $b = 1;


    for ( my $i=1;$i < $n;$i++ ) {
        my $c = $a;
        $a = $b;
        $b += $c;
    }
    return $b;
} ## --- end sub cal



