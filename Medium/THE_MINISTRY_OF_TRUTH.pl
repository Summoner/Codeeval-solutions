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
	    push @list,[split /;/,$_];
	}
close $input;

#print Dumper \@list;

foreach my $arr ( @list ) {

   print  main( $arr ),"\n";
}

sub main {
    my	( $arr )	= @_;

    my @mainWords = split /\s+/,$arr->[0];
    my @patternWords = split /\s+/,$arr->[1];

    my @result = ();
    my $isExist = 0;
    my $index = 0;

    foreach my $i (0..$#patternWords ) {

        if ( $index == scalar @mainWords ){

            @result = ();
            $isExist = 0;
            last;
        }
        foreach my $j ($index..$#mainWords ) {

            if ( isSubstr( $mainWords[$j],$patternWords[$i] ) ){

                $isExist = 1;
                push @result,form( $mainWords[$j], $patternWords[$i] );
                $index = $j+1;
                last;
            }else{

               push @result, ( "_" x length( $mainWords[$j] ));
            }
        }
    }
    if ( $isExist && ( scalar @mainWords > scalar @result) ){

        foreach ( scalar @result .. scalar @mainWords-1 ) {

            push @result, "_" x length ( $mainWords[$_] );
        }
    }
    unless ( $isExist ){

        return "I cannot fix history";
    }
    return join (" ",@result);
} ## --- end sub main

sub form {
    my	( $str,$pattern )	= @_;
    my @mainStr = ( ("_") ) x length($str);
    my $startPos = index( $str,$pattern );
    my $position = 0;

    for ( my $i = $startPos; $i < $startPos + length($pattern); $i++ ) {

        $mainStr[$i] = substr( $pattern, $position,1 );
        $position++;
    }
    return join ("",@mainStr);
} ## --- end sub form

sub isSubstr {
    my	( $str,$substr )	= @_;

    return 1 if ( $str =~ /$substr/);
    return 0;
} ## --- end sub is_substr

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n"
