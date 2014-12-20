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
        chomp $_;
	    push @list,[split /;/,$_];
	}
close $input;

#print Dumper \@list;
foreach my $arr ( @list ) {

    calc( $arr->[0],$arr->[1] );
}


sub calc {
    my	( $str1,$str2 )	= @_;
    my @arr1 = split /,/,$str1;
    my @arr2 = split /,/,$str2;
    my @result = ();
    my %hash1 = ();

    foreach my $elem ( @arr1 ) {

        $hash1{$elem}++;
    }

    foreach my $elem ( @arr2 ) {

       if (exists $hash1{$elem}){

            push @result,$elem;
       }
    }

    print " " if ( scalar @result == 0 );
    print join ( ",",@result ),"\n";

} ## --- end sub calc
my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
