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
	push @list,$_;
	}
close $input;

#print Dumper \@list;

foreach my $str (@list){

  primes1($str); 
}

sub primes1 {
    my	( $limit )	= @_;

    my @table = ();

    push @table,2;

    for ( my $i= $table[0]+1;$i < $limit ;$i++ ) {

        my $prime = 1;
        for ( my $j = 0;$j < scalar @table && $table[$j] * $table[$j] <= $i;$j++ ) {

            if ($i % $table[$j] == 0){
            
                $prime = 0;
                last;
            }
        }

        push @table,$i if ($prime);
    }

    print join (",", sort {$a <=> $b} @table),"\n";
} ## --- end sub primes1


my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
