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
	    push @list,[split /\s+\|\s+/,$_];
	}
close $input;

foreach my $arr ( @list ) {
    my $coordinats = [];
    foreach my $element ( @$arr ) {
        my ($x,$y) = split /\s+/,$element;
        push @$coordinats,$x,$y;
    }
    print calc( $coordinats,scalar @$arr ),"\n";
}

sub calc {
    my	( $coordinats,$pointsCount )	= @_;
    my $count = 0;

    for ( my $i = 0; $i < $pointsCount - 2; $i++ ) {
        for ( my $j = $i+1; $j < $pointsCount - 1; $j++ ) {
            my $dx = $coordinats->[$i * 2] - $coordinats->[$j * 2];
            my $dy = $coordinats->[$i * 2 + 1] - $coordinats->[$j * 2 + 1];
            #print "dx: $dx\n";
            #print "dy: $dy\n";

            for ( my $k = 0; $k < $pointsCount; $k++ ) {
                if ( $k != $i && $k != $j && ($dx * ( $coordinats->[$i * 2 + 1] - $coordinats->[$k * 2 + 1] ) == $dy* ( $coordinats->[$i * 2] - $coordinats->[$k * 2] )) ){
                    $count++ if ( $k > $j );
                    #print "break here\n";
                    last;
                }
            }
        }
    }
    return $count;
} ## --- end sub calc

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
