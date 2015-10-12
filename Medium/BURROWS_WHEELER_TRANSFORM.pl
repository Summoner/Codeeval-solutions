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

#print Dumper \@list;

foreach my $str ( @list ){

   print Calc( $str ),"\n";
}

sub Calc {
    my	( $arr )	= @_;

    pop @$arr;
    my @final = ("") x scalar @$arr;

    map { @final =sort map{ $final[$_] = $arr->[$_] . $final[$_]  }0..$#{ $arr } }0..$#{ $arr };

    my @res = grep{ $_ =~ /^.*\$$/ }@final;
    return $res[0];
} ## --- end sub Calc1

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
