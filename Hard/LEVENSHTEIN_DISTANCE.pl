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
	    push @list,$_;
	}
close $input;

my %graph = ();
my @tests = ();
my $word = shift @list;
  
 while ( $word ne "END OF INPUT"){
 
      push @tests, $word;  
      $word = shift @list;
 }


#print Dumper \@tests;
#print Dumper \@list;


 foreach my $test_word ( @tests ) {

     foreach my $word ( @list ) {

         if ( Levenstein_Distance( $test_word,$word ) == 1 ){
         
            add_friend( $test_word,$word ); 
         }
     }
 }


 foreach my $test_word ( @tests ) {

    print find_all( {},$test_word ),"\n";

}
sub find_all {
    my	( $seen,$start ) = @_;

    $seen->{$start} = 1;
    my $count = 0;
    
    foreach my $node (keys %{$graph{$start}}  ) {

        next if ( $seen->{$node} );
        $count++;
        $count += find_all( $seen, $node );
    }

    return $count;
} ## --- end sub find_all

sub add_friend {
    my	( $n1, $n2 )	= @_;

    $graph{$n1}{$n2} = 1;
    $graph{$n2}{$n1} = 1;
    
} ## --- end sub add_friend




sub Levenstein_Distance {
    my	( $s,$t )	= @_;

    my @s = split //,$s;
    my @t = split //,$t;
    return 0 if ( $s eq $t );
    return length( $t ) if ( length( $s ) == 0 );
    return length( $s ) if ( length( $t ) == 0 );
    
    my @V0 = (); $V0[length($t)+1] = undef;
    my @V1 = (); $V1[length($t)+1] = undef;

    
    for ( my $i=0;$i < scalar @V0;$i++) {

        $V0[$i] = $i;
    }


    for ( my $i=0;$i < length( $s );$i++ ) {

        $V1[0] = $i+1;


        for ( my $j=0; $j < length( $t );$j++ ) {

            my $cost = ( $s[$i] eq $t[$j] ) ? 0 : 1;
            $V1[$j+1] = min( $V1[$j]+1, $V0[$j+1] + 1,$V0[$j]+$cost);
        }

        for ( my $j=0; $j < scalar @V0; $j++ ) {

            $V0[$j] = $V1[$j];
        }

    }

    return $V1[length($t)] ;
} ## --- end sub Levenstein_Distance


sub min {
    my	( $x,$y,$z ) = @_;

    my @arr = ($x,$y,$z);

    my @sorted = sort{ $a <=> $b }@arr;

    return $sorted[0];
} ## --- end sub min
my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
