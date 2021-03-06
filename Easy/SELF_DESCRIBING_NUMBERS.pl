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
foreach my $digit ( @list ) {

    print isSelfDescribing($digit),"\n";

}

sub isSelfDescribing {
    my	( $digit )	= @_;

    my @digits = split //,$digit;
    my %countDigits = ();
    my $isSelfDescribing = 1;

    grep { $countDigits{$_}++ } @digits;

    for ( my $i = 0; $i <= $#digits; $i++ ) {

        my $counts = $digits[$i];
        if ( !exists $countDigits{$i} ){

            $countDigits{$i} = 0;

        }
        if ( $countDigits{$i} != $counts ){

            $isSelfDescribing = 0;
            last;
        }
    }
    return $isSelfDescribing;
} ## --- end sub isSelfDescribing

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
