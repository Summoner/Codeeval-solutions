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
my @card_number = ();
foreach my $arr ( @list ){

     @card_number = ();
    
    foreach my $digit ( @$arr ) {

        push @card_number, ( split //,$digit );
    }

   print is_valid( \@card_number ),"\n";
}

sub is_valid {
    my	( $card_number )	= @_;

    my @digits = @$card_number;


    for ( my $i = $#digits-1; $i >= 0; $i -= 2  ) {

        my $digit = $digits[$i];

        $digit *= 2;

        if ( $digit > 9 ){
        
            my @temp = split //,$digit;
            my $summ = 0;

            foreach ( @temp ) {
                $summ += $_;
            }
            $digit = $summ;
        }

        $digits[$i] = $digit;
    }

    my $summ_all = 0;
    foreach ( @digits ) {

        $summ_all += $_;
    }
    return 1 if ( $summ_all % 10 == 0 );
    return 0;
} ## --- end sub is_valid
my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
