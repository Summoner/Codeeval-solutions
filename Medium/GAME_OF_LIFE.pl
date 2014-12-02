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
	push @list,[split //,$_];
	}
close $input;

#print Dumper \@list;

my $greed = [];

for my $i (0.. $#list ) {

    for my $j ( 0..$#{$list[$i]} ) {
    
        my $cell = {};
        $cell->{ ALIVE } = 1 if $list[$i]->[$j] eq "*";
        $cell->{ ALIVE } = 0 if $list[$i]->[$j] eq ".";
        $greed->[$i]->[$j] = $cell;
    }
}


calc_neighbors( $greed );

my $count = 1;

while ( $count <= 10 ){

    for ( my $i=0; $i <= $#{ $greed }; $i++ ) {

        for ( my $j=0; $j <= $#{$greed->[$i]}; $j++ ) {

            if ( $greed->[$i]->[$j]->{ALIVE} == 1 ){

                if ( $greed->[$i]->[$j]->{N} < 2 ){
           
                    $greed->[$i]->[$j]->{ALIVE} = 0;
                
                }elsif ( $greed->[$i]->[$j]->{N} == 2 || $greed->[$i]->[$j]->{N} == 3 ){
            
                    next;

                }elsif ( $greed->[$i]->[$j]->{N} > 3 ){
            
                    $greed->[$i]->[$j]->{ALIVE} = 0;
                }

            }elsif ( $greed->[$i]->[$j]->{ALIVE} == 0 ){

                if ( $greed->[$i]->[$j]->{N} == 3 ){
            
                    $greed->[$i]->[$j]->{ALIVE} = 1;
                }
            }
        }
    }
calc_neighbors( $greed );

$count++;
}

show_greed( $greed );


sub calc_neighbors {
    my	( $greed )	= @_;
    
    for ( my $i=0; $i <= $#{ $greed }; $i++ ) {

        for ( my $j=0; $j <= $#{$greed->[$i]}; $j++ ) {
        
            my $n = calc_neighbor( $greed, $i,$j );
            $greed->[$i]->[$j]->{N} = $n;            
        }
    }
} ## --- end sub calc_neighbors

sub calc_neighbor {
    my	( $greed, $i,$j )	= @_;
   
    my $summ = 0;

        $summ++ if ( is_alive( $greed,$i+1,$j ));
        $summ++ if ( is_alive( $greed,$i-1,$j ));
        $summ++ if ( is_alive( $greed,$i,$j+1 ));
        $summ++ if ( is_alive( $greed,$i,$j-1 ));
        $summ++ if ( is_alive( $greed,$i+1,$j+1 ));
        $summ++ if ( is_alive( $greed,$i-1,$j-1 ));
        $summ++ if ( is_alive( $greed,$i+1,$j-1 ));
        $summ++ if ( is_alive( $greed,$i-1,$j+1 ));
   
    return $summ ;
} ## --- end sub calc_neighbors


sub is_alive {
    my	( $greed, $i, $j )	= @_;

    return 0 if ( $i < 0 || $j < 0 || $i > $#{ $greed } || $j > $#{$greed->[$i]} );

    return $greed->[$i]->[$j]->{ALIVE};
} ## --- end sub is_alive
sub show_greed {
    my	( $greed )	= @_;

    for ( my $i=0; $i <= $#{ $greed }; $i++ ) {

        for ( my $j=0; $j<= $#{$greed->[$i]}; $j++ ) {
        
            #print "$greed->[$i]->[$j]->{N}\t";
            print ".\t" if ( $greed->[$i]->[$j]->{ALIVE} == 0 );
            print "*\t" if ( $greed->[$i]->[$j]->{ALIVE} == 1 );

        }
    print "\n";
    }   
} ## --- end sub show_greed
my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
