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
	push @list,[split /\s+\|\s+/,$_];
	}
close $input;

#print Dumper \@list;

foreach my $arr (@list){

    my $numbers = [];
    @$numbers = split /\s+/,$arr->[0];
    my $iterations = $arr->[1];

    calc( $numbers,$iterations );
    print join " ",@$numbers,"\n";
}


sub calc {
    my	( $arr,$iterationsNumber )	= @_;

    my $count = 0;
    for ( my $i=0; $i <= $#{ $arr }; $i++ ) {

        for ( my $j = 0;$j < $#{ $arr };$j++ ) {

            ( $arr->[$j+1],$arr->[$j] ) = ( $arr->[$j],$arr->[$j+1] ) if ( $arr->[$j] > $arr->[$j+1] ); 
        }
        $count++;
        last if ( $count == $iterationsNumber );
    }
    return $arr;
} ## --- end sub calc

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
