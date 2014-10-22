#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper; 
use Benchmark;

my $t0 = new Benchmark;
open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
# open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";



my @cars = (); 
	 
	while(<$input>){			
	chomp;	
	push @cars,[split /\s+/,$_];
	}
close $input;

my $car_track = [];

$car_track = shift @cars;

my %cars = ();

foreach my $car (@cars){

    my @car_track = @$car_track;
    my $time_lapce = 0;
    my $t1 = $car->[2];
    my $t2 = $car->[3];
    my $v_top = $car->[1]/3600;
    my $a1 = $v_top/$t1;
    my $a2 = $v_top/$t2;

    $time_lapce = calc_part_time(\@car_track,$a1,$a2,$v_top,0,$time_lapce);
    $cars{$car->[0]} =  sprintf("%.2f",$time_lapce); 
}

foreach my $key (sort{$cars{$a} <=> $cars{$b}} keys %cars ) {

    print "$key $cars{$key}\n";
}

sub calc_part_time {
    my	( $car_track,$a1,$a2,$v_top,$v_start,$time_lapce )	= @_;

    return $time_lapce if (scalar @$car_track == 0);

    my $S = shift @$car_track;
    my $angle = shift @$car_track;

    my $t1 = ($v_top - $v_start)/$a1;

    my $S1 = $v_start * $t1 + 0.5 * $a1 * $t1* $t1;

    my $v_turn = (1 - $angle/180.0) * $v_top;
    
    my $t2 = ($v_top - $v_turn) / $a2;

    my $S2 = $v_top * $t2 - 0.5 * $a2 * $t2 * $t2;

    my $S3 = $S - $S1 - $S2;

    my $t3 = $S3 / $v_top;

    $time_lapce += ($t1 + $t3 + $t2);
    
    calc_part_time($car_track,$a1,$a2,$v_top,$v_turn,$time_lapce);
} ## --- end sub calc


my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
