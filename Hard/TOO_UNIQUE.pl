#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper; 
use Benchmark;

my $t0 = new Benchmark;

  open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
 #open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";

my $matrix = []; 
	 
	while(<$input>){
    	chomp;	
	    push @$matrix,[split //,$_];
	}
close $input;



foreach my $arr ( @$matrix ) {

    print "@$arr\n";
}

sub are_uniq {
    my	( $matrix )	= @_;

    my %hash = ();
    
    for ( my $i=0; $i <= $#{$matrix}; $i++ ) {

        for ( my $j=0; $j <= $#{$matrix->[$i]}; $j++ ) {

            $hash{ $matrix->[$i]->[$j] }++;
        }
    }
    my @result = grep { $_>1 } values %hash;

    return 0 if ( scalar @result > 0 );
    return 1;
} ## --- end sub are_uniq
my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
