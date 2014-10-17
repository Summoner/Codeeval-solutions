#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper; 
use Benchmark;


my $t0 = new Benchmark;

open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
# open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";


my @list = ();
my %coins_hash = (
0.01 => "PENNY",
0.05 => "NICKEL",
0.10 => "DIME",
0.25 => "QUARTER",
0.50 => "HALF DOLLAR",
1.00 => "ONE",
2.00 => "TWO",
5.00 => "FIVE",
10.00 => "TEN",
20.00 => "TWENTY",
50.00 => "FIFTY",
100.00 => "ONE HUNDRED"
);

my @coins = grep{ $_ }sort{ $b<=>$a }keys %coins_hash;

while(<$input>){
	
	chomp;
	push @list,[split /;/,$_];
	
}
close $input;


foreach (@list){
	
	my $price = $_->[0];
    my $cash = $_->[1];

    if ($price > $cash){
         print "ERROR\n";
         next;
     }
    if ($price == $cash){
   
        print "ZERO\n";
        next;
    }

    my $change = sprintf("%.2f",$cash - $price);
	print deep($change,[]),"\n";
	
}

sub deep {
    my	( $change, $res )	= @_;

    return join ",",@$res if ( $change == 0 );
    $change = sprintf("%.2f",$change); 
    foreach my $coin ( @coins ) {

        next if ($coin > $change);
        $change -= $coin;
        push @$res,$coins_hash{$coin};
        last;
    }

    deep($change,$res);
} ## --- end sub deep

print "\n";
my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
