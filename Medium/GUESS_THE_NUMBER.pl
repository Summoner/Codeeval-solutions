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

foreach ( @list ){

    my $value = shift @$_;
    my @arr = ( );

    foreach my $i ( 0..$value ) {

        push @arr, $i;
    }
    # $DB::single = 2;
   print search(\@arr,$_),"\n";
}


sub search {
    my	( $arr,$words )	= @_;

    my $word = shift @$words;
    
    my $upper = int (scalar @$arr / 2);

    if ( $word eq "Higher" ){
    
        splice ( @$arr, 0,$upper+1 );
        search( $arr,$words );

    }elsif( $word eq "Lower" ){
   
        $upper++ if ( scalar @$arr % 2 != 0 );
        splice( @$arr,-$upper );
        search( $arr,$words );

    }elsif( $word eq "Yay!" ){
    
        return $arr->[$upper];
    }

    
} ## --- end sub search
	

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
