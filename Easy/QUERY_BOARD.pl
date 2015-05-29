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
        push @list,[split /\s+/,$_];
	}
close $input;

my $board = createBoard();
#print Dumper \@list;
foreach my $arr ( @list ) {

    if ( $arr->[0] =~ m/SetCol/ ){

        setColumn( $board,$arr->[1],$arr->[2] );

    }elsif ( $arr->[0] =~ m/SetRow/ ){

        setRow( $board,$arr->[1],$arr->[2] );

    }elsif ( $arr->[0] =~ m/QueryCol/ ){

        queryColumn( $board,$arr->[1] );

    }elsif ( $arr->[0] =~ m/QueryRow/ ){

        queryRow( $board,$arr->[1] );

    }
}

sub createBoard {
    my	( $board )	= @_;

    for ( my $i = 0; $i < 256; $i++ ) {

        for ( my $j=0; $j < 256; $j++ ) {

            $board->[$i]->[$j] = 0;
        }
    }
    return $board;
} ## --- end sub createBoard

sub setRow {
    my	( $board,$row,$val )	= @_;

    for ( my $j = 0; $j <= $#{$board->[$row]}; $j++ ) {

        $board->[$row]->[$j] = $val;
    }
} ## --- end sub setRow

sub setColumn {
    my	( $board,$col,$val )	= @_;

    for ( my $i = 0; $i <= $#{$board}; $i++ ) {

        $board->[$i]->[$col] = $val;
    }
} ## --- end sub setColumn

sub queryRow {
    my	( $board,$row )	= @_;
    my $result = 0;

    for ( my $j = 0; $j <= $#{$board->[$row]}; $j++ ) {

        $result += $board->[$row]->[$j];
    }
    print $result,"\n";
} ## --- end sub queryRow

sub queryColumn {
    my	( $board,$col )	= @_;
    my $result = 0;

    for ( my $i = 0; $i <= $#{$board}; $i++ ) {

        $result += $board->[$i]->[$col];
    }
    print $result,"\n";
} ## --- end sub queryColumn



my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
