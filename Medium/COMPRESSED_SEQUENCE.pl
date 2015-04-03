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

#print Dumper \@list;

foreach my $arr ( @list ){

    calc( $arr );
}

sub calc {
    my	( $arr )	= @_;

    my $count = 0;
    my $currentEl = $arr->[0];
    my $result = [];
    foreach my $elem ( @$arr ) {

        if ( $elem == $currentEl ){

            $count++;

        }else{
            push @$result, ( $count,$currentEl );
            $count = 1;
            $currentEl = $elem;
        }
    }
    push @$result, ( $count,$currentEl );
    print join " ",@$result,"\n";
} ## --- end sub calc


my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
