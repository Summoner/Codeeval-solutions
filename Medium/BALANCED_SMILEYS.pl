#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper;
use Benchmark;

my $t0 = new Benchmark;
open my $input, "D:\\Perl\\input.txt" || die "Can't open file: $!\n";
#open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";

my @list = ();

while(<$input>){

	chomp;
	push @list, $_;

}
close $input;

foreach(@list){

    my @str = split //,$_;

}




sub valid {
    my	( $str, $cur )	= @_;

    return 0 if ( $cur < 0 );
    return $cur = 0 if ( scalar  );


    return ;
} ## --- end sub valid
my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
