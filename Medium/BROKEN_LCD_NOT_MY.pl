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

foreach my $str (@list){

    print calc($str->[0],$str->[1]),"\n";
}

sub calc {

    my ($brokenDisplStr,$inpDigit) = @_;
    my $broken_d = [];
    @$broken_d = map{[split //,$_]} split /\s+/,$brokenDisplStr;
    my $needToShow = [];
    my $possible = 0;

    my $bin_d = [   [1,1,1,1,1,1,0,0],
                    [0,1,1,0,0,0,0,0],
                    [1,1,0,1,1,0,1,0],
                    [1,1,1,1,0,0,1,0],
                    [0,1,1,0,0,1,1,0],
                    [1,0,1,1,0,1,1,0],
                    [1,0,1,1,1,1,1,0],
                    [1,1,1,0,0,0,0,0],
                    [1,1,1,1,1,1,1,0],
                    [1,1,1,1,0,1,1,0]
    ];

    my @inpDigits = split//,$inpDigit;

    foreach my $digit ( @inpDigits ) {
        if ( $digit eq "." ){
            if ( scalar @$needToShow > 0 ){
                $needToShow->[-1]->[-1] = 1;
            }else{
                my @temp = @{$bin_d->[0]};
                $temp[-1] = 1;
                push @$needToShow,\@temp;
            }
        }else{
            my @temp = @{$bin_d->[$digit]};
            push @$needToShow,\@temp;
        }
    }

    for ( my $k = 0; $k < (scalar @$broken_d - scalar @$needToShow); $k++ ) {

        my $needToShowCount = 0;
        my $brokenDisplayCount = $k;

        while ( $needToShowCount <= $#{$needToShow} ){
            $possible = compareParts($needToShow->[$needToShowCount],$broken_d->[$brokenDisplayCount] );
            last unless $possible;
            $needToShowCount++;
            $brokenDisplayCount++;
        }
        last if ( $possible );
    }
    return $possible;
} ## --- end sub calc

sub compareParts {
    my	( $forShow,$lcd )	= @_;
    my $res = 1;

    for ( my $i =0; $i <= $#{$lcd}; $i++ ) {
        unless ( $lcd->[$i] >= $forShow->[$i]){
            $res = 0;
            last;
        }
    }
    return $res;
} ## --- end sub compareParts



my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
