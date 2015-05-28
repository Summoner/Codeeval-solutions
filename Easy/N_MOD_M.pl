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
        push @list,[split /,/,$_];
	}
close $input;

#print Dumper \@list;
foreach my $arr ( @list ) {

    my $N = $arr->[0];
    my $M = $arr->[1];

    print remainder( $N,$M ),"\n";
}

sub remainder {
    my	( $N,$M )	= @_;

    return 0 unless  $M && $N;
    return $N if ( $M > $N );
    my $res = int( $N/$M );
    my $remainder = $N - ( $res * $M );

} ## --- end sub remainder

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
