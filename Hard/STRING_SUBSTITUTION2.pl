#!/usr/bin/env perl -w
use strict;
use warnings;
use Data::Dumper;

open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
# open my $result, ">D:\\Perl\\output.txt" || die "Can't open file: $!\n";

my @list = ();

while(<$input>){

	chomp;
	my ( $input_string,$replacements ) = split /;/,$_;
    my $temp = [split /,/,$replacements ];
    unshift @$temp,$input_string;
    push @list,$temp;
}
close $input;
#print "***************************************************************************************************************\n";
#print Dumper \@list;

foreach my $arr ( @list ) {

    replace( $arr );
}

sub replace {
    my	( $arr )	= @_;

    my @string = split //,shift $arr;
    my @patterns = @$arr;
    my @dubl_string = ();
    #$DB::single = 2;
    #print Dumper \@patterns;
    for ( my $i=0; $i <= $#patterns; $i+=2 ) {

        my @replacement = split //,$patterns[$i+1];
        my @pattern = split //,$patterns[$i];
        searching_substring( \@string,\@dubl_string,\@pattern,\@replacement );
    }

    for ( my $i=0; $i<= $#string; $i++ ) {

        next unless ( defined $string[$i] );
        $dubl_string[$i] = $string[$i];
    }

    print join "", @dubl_string;
} ## --- end sub replace


sub searching_substring {
    my	( $string,$dubl_string,$pattern,$replacement )	= @_;

    for ( my $i=0; $i<= $#{$string}; $i++ ) {

        next unless ( defined $string->[$i] );
        unless ( $string->[$i] == $pattern->[0]){

            next;

        }else{

            change_arrays( $string,$dubl_string,$pattern,$replacement,$i,$i+$#{$pattern} );
        }
    }

    #  print Dumper \$string;
    #  print Dumper \$dubl_string;
} ## --- end sub searching_substring


sub change_arrays {
    my	( $string,$dubl_string,$pattern,$replacement,$start_index,$stop_index ) = @_;

    my $index = 0;
    for ( my $i = $start_index; $i <= $stop_index; $i++ ) {

        if ( !defined $string->[$i] || $string->[$i] != $pattern->[$index] ){

            return;
       }
       $index++;
    }

    for ( my $i = $start_index; $i <= $stop_index; $i++ ) {

        $string->[$i] = undef;
    }

    my $index_repl = 0;
    for ( my $i = $start_index; $i <= $start_index + $#{$replacement}; $i++ ) {

        $dubl_string->[$i] = $replacement->[$index_repl];
        $index_repl++;
    }

} ## --- end sub change_arrays


