#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper; 
use Benchmark;

my $t0 = new Benchmark;

  open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
 #open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";

my @list = (); 
	 
	while(<$input>){
    	chomp;	
	    push @list,[split //,lc $_];
	}
close $input;


my $board1 = [
    ["a","b","c","e"],
    ["s","f","c","s"],
    ["a","d","e","e"]
];

my $board = [];

for ( my $i=0;$i <= $#{$board1} ;$i++ ) {

    for ( my $j=0;$j <= $#{$board1->[$i]};$j++ ) {

        my $hash = {};
            $hash->{VALUE} = $board1->[$i]->[$j];
            $hash->{STATUS} = 0;
            $board->[$i]->[$j] = $hash;
    }
}


my %ranges = ();

$ranges{a} = [ [0,0],[2,0] ];
$ranges{b} = [ [0,1] ];
$ranges{c} = [ [0,2],[1,2] ];
$ranges{e} = [ [0,3],[2,2],[2,3] ];
$ranges{s} = [ [1,0],[1,3] ];
$ranges{f} = [ [1,1] ];
$ranges{d} = [ [2,1] ];


foreach my $word ( @list ) {

    input( $word );
    clear_board();
}

sub input {
    my	( $word )	= @_;

    my @indexes = @{ $ranges{$word->[0]} }; 
    my $if_exist = 0;

    foreach my $inp ( @indexes ) {

        if  ( deep( $word,0,$inp->[0],$inp->[1] ) ){
        
             $if_exist = 1;
             last; 
        }        
    }

    if ( $if_exist ){

        print "True\n";

    }else{

        print "False\n";
    }
    
} 
  
sub deep {
    my	( $word,$next,$i,$j )	= @_;


    return 1 if ( $next == scalar @$word );
    return 0 if ( $i < 0 || $j < 0 || $i > 2 || $j > 3 || $board->[$i]->[$j]->{STATUS} == 1 );
    

    my $is_match = 0;
    if ( $board->[$i]->[$j]->{VALUE} eq $word->[$next] &&  $board->[$i]->[$j]->{STATUS} == 0 ){
    
        $board->[$i]->[$j]->{STATUS} = 1;
        $is_match = 1;    
    }

    return 0 unless( $is_match );

    return 1 if deep( $word, $next+1, $i+1,$j );
    return 1 if deep( $word, $next+1, $i-1,$j );
    return 1 if deep( $word, $next+1, $i,$j+1 );
    return 1 if deep( $word, $next+1, $i,$j-1 );
    return 0;
    
} ## --- end sub deep


sub clear_board {
    
    for ( my $i=0;$i <= $#{$board1} ;$i++ ) {

        for ( my $j=0;$j <= $#{$board1->[$i]};$j++ ) {

            $board->[$i]->[$j]->{STATUS} = 0;
        }
    }
} ## --- end sub clear_board


my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
