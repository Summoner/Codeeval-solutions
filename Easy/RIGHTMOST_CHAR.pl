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
        push @list, [split /,/,$_];

    }
close $input;

foreach my $arr ( @list ) {

    print occurence($arr->[0],$arr->[1]),"\n";
}

sub occurence {
    my	( $word,$symb )	= @_;

    my $map = {};
    my @word = split //,$word;

    $map = get_map( \@word );

    my @indexes = @{$map->{$symb}} if exists ( $map->{$symb} );

    unless ( scalar @indexes == 0 ){

        my @sorted_i = sort {$b<=>$a}@indexes;
        return $sorted_i[0];
    }else{
        return -1;
    }
} ## --- end sub occurence

sub get_map {
    my	( $word )	= @_;

    my $map = {};
    foreach my $i ( 0..$#{$word} ) {

        next if ($word->[$i] eq " ");
        push @{$map->{$word->[$i]}},$i;
    }
    return $map;
} ## --- end sub get_map


my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
