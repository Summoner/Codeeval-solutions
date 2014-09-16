#!/usr/bin/env perl -w
use strict;
use warnings;
use utf8;
use Data::Dumper; 

open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
# open my $result, ">D:\\Perl\\output.txt" || die "Can't open file: $!\n";

my @list = ();

while(<$input>){
	
	chomp;
	push @list,[split /,/,$_];
	
}
close $input;


foreach my $arr (@list) {
    print str_compare($arr->[0],$arr->[1]);
}


sub str_compare {
    my	( $str1,$str2 )	= @_;

    if ($str2 =~ /^\*/){
        $str2 =~ s/^\*/\\\*/;
    }
    if ($str2 =~ /^\\[^\*]/){
        $str2 =~ s/^\\/\\\\/;
        print $str2,"\n";
    }

    return "true\n" if $str1 =~ /$str2/i ;
    return "false\n";
} ## --- end sub compare
