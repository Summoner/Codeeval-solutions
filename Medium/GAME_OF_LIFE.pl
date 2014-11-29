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
my $arr = [];
for my $i ( 0..$#{$greed->[0]} ) {
    
        my $cell = {};
        $cell->{ ALIVE } = 0;
        push @$arr,$cell;
}

unshift @$greed,$arr;
push @$greed,$arr;

for my $i ( 0..$#{$greed} ) {
    
        my $cell = {};
        $cell->{ ALIVE } = 0;
        unshift @{$greed->[$i]},$cell;
        push @{$greed->[$i]},$cell;
}
#$DB::single = 2;
#show_greed( $greed );
print "\n";

for ( my $i=1; $i < $#{ $greed }; $i++ ) {

    for ( my $j=1; $j < $#{$greed->[$i]}; $j++ ) {
        
            my $n = calc_neighbors( $greed, $i,$j );
            $greed->[$i]->[$j]->{N} = $n;            
    }
}
show_greed( $greed );
print "\n";
my $count = 1;

while ( $count <= 10 ){

    for ( my $i=1; $i < $#{ $greed }; $i++ ) {

        for ( my $j=1; $j < $#{$greed->[$i]}; $j++ ) {

            if ( ($greed->[$i]->[$j]->{N} < 2) && ( $greed->[$i]->[$j]->{ALIVE} == 1) ){
           
                $greed->[$i]->[$j]->{ALIVE} = 0;

                decrease_neighb( $greed,$i,$j );
                   
            }elsif (  ($greed->[$i]->[$j]->{N} == 2 || $greed->[$i]->[$j]->{N} == 3 ) &&  ( $greed->[$i]->[$j]->{ALIVE} == 1) ){
            
                next;

            }elsif ( ($greed->[$i]->[$j]->{N} > 3)  && ($greed->[$i]->[$j]->{ALIVE} == 1) ){
            
                $greed->[$i]->[$j]->{ALIVE} = 0;

                decrease_neighb( $greed,$i,$j )

            }elsif ( ($greed->[$i]->[$j]->{N} == 3) && ($greed->[$i]->[$j]->{ALIVE} == 0) ){
            
                $greed->[$i]->[$j]->{ALIVE} = 1;
                
                increase_neighb( $greed,$i,$j );               
            }

        }
    }
show_greed( $greed );
print "\n";

    $count++;
}

show_greed( $greed );


sub calc_neighbors {
    my	( $greed, $i,$j )	= @_;
   
    my $summ = 0;

        $summ++ if ( $greed->[$i+1]->[$j]->{ALIVE} == 1 );
        $summ++ if ( $greed->[$i-1]->[$j]->{ALIVE} == 1 );
        $summ++ if ( $greed->[$i]->[$j+1]->{ALIVE} == 1 );
        $summ++ if ( $greed->[$i]->[$j-1]->{ALIVE} == 1 );
        $summ++ if ( $greed->[$i+1]->[$j+1]->{ALIVE} == 1 );
        $summ++ if ( $greed->[$i-1]->[$j-1]->{ALIVE} == 1 );
        $summ++ if ( $greed->[$i+1]->[$j-1]->{ALIVE} == 1 );
        $summ++ if ( $greed->[$i-1]->[$j+1]->{ALIVE} == 1 );
   
    return $summ ;
} ## --- end sub calc_neighbors

sub decrease_neighb {
    my	( $greed,$i,$j )	= @_;

     $greed->[$i+1]->[$j]->{N}--;
     $greed->[$i-1]->[$j]->{N}--;
     $greed->[$i]->[$j+1]->{N}--;
     $greed->[$i]->[$j-1]->{N}--;
     $greed->[$i+1]->[$j+1]->{N}--;
     $greed->[$i-1]->[$j-1]->{N}--;
     $greed->[$i+1]->[$j-1]->{N}--;
     $greed->[$i-1]->[$j+1]->{N}--;

} ## --- end sub decrease_neighb

sub increase_neighb {
    my	( $greed, $i,$j )	= @_;

     $greed->[$i+1]->[$j]->{N}++;
     $greed->[$i-1]->[$j]->{N}++;
     $greed->[$i]->[$j+1]->{N}++;
     $greed->[$i]->[$j-1]->{N}++;
     $greed->[$i+1]->[$j+1]->{N}++;
     $greed->[$i-1]->[$j-1]->{N}++;
     $greed->[$i+1]->[$j-1]->{N}++;
     $greed->[$i-1]->[$j+1]->{N}++;

} ## --- end sub increase_neighb


sub show_greed {
    my	( $greed )	= @_;

 for ( my $i=1; $i < $#{ $greed }; $i++ ) {

    for ( my $j=1;$j< $#{$greed->[$i]}; $j++ ) {
        
       print "$greed->[$i]->[$j]->{N} --> $greed->[$i]->[$j]->{ALIVE} \t";
       # print ".\t" if ( $greed->[$i]->[$j]->{ALIVE} == 0 );

    }
    print "\n";
}   


} ## --- end sub show_greed
my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
