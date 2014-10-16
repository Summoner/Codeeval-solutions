#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper; 
use Benchmark;

my $t0 = new Benchmark;

# (1,6), (6,7), (2,7), (9,1)
# (4,1), (3,4), (0,5), (1,2)
# (4,6), (5,5), (5,6), (4,5)

open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
#open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";

my @list = (); 
	 
	while(<$input>){			
	chomp;	
	push @list,$_;
	}
close $input;


foreach(@list){
	
	 my @arr = $_=~ /\-?\d+\,\-?\d+/g;
     print find_square(\@arr),"\n";
}


sub find_square {
    my	( $points )	= @_;

    my $center = [0,0];
    my @koordinates = ();
    foreach my $koord_pair(@$points){
		
	    my ($x,$y) = split ",", $koord_pair;
	    push @koordinates,[$x,$y];
    }

    
    foreach my $koord ( @koordinates ) {

        $center->[0] += $koord->[0];
        $center->[1] += $koord->[1];
    }

    $center->[0] = $center->[0] / 4;
    $center->[1] = $center->[1] / 4;
    
    my $pc = diff($koordinates[0],$center);
    
    my $distance_squared = dot($pc,$pc);

    foreach my $point ( @koordinates ) {

        my $point_to_center = diff($point,$center);
        return "false" if ($distance_squared != dot($point_to_center,$point_to_center)); 
    }

    my $count = 0;
    foreach my $point ( @koordinates ) {
        
        $count++ if (dot(diff($point,$center),$pc)== 0);
    }

    return "true" if ($count == 2);
    return "false";
} ## --- end sub find_square

sub dot {
    my	( $a,$b )	= @_;

    return $a->[0] * $b->[0] + $a->[1] * $b->[1];

} ## --- end sub dot


sub diff {
    my	( $a,$b )	= @_;

    return [$b->[0] - $a->[0],$b->[1] - $a->[1]];
    
} ## --- end sub diff


my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
