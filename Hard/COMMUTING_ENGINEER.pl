#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper; 
use Benchmark;

my $t0 = new Benchmark;

  open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
  #open my $result, ">/home/fanatic/Summoner/Codeeval-solutions/output1.txt" || die "Can't open file: $!\n";

my @points = (); 
my $count = 0;
	while(<$input>){
    	chomp;
        $count++;
        $_ =~ /\((\-*\d+\.\d*),\s+(\-*\d+\.\d*)\)/g;

        my $point = {};
        $point->{n} = $count;
        $point->{x} = $1;
        $point->{y} = $2;
	    push @points,$point;
	}
close $input;

#print Dumper \@points;
unshift @points,0;

my $matrix = [];

for ( my $j=1; $j < scalar @points; $j++ ) {

    $matrix->[0]->[$j] = $points[$j]->{n};
}

for ( my $i=1; $i < scalar @points; $i++ ) {

    $matrix->[$i]->[0] = $points[$i]->{n};
}

for ( my $i=1; $i < scalar @points; $i++ ) {

    for ( my $j=1; $j < scalar @points; $j++ ) {

        next if ( $i == $j );
        my $hash = {};
        $hash->{STATUS} = 0;
        $hash->{VALUE} = calc( $points[$i],$points[$j] );
        $matrix->[$i]->[$j] = $hash;

        print "i: $i ---> j:$j : $hash->{VALUE}\n";
    }
}
#show( $matrix );
#$DB::single = 2;

my @res = salesman(1);



foreach my $elem ( @res ) {


    print "$elem\n";
}
#show( $matrix );

sub show {
    my	( $matrix )	= @_;

    for ( my $i=0; $i <= $#{$matrix}; $i++ ) {

        for ( my $j=0; $j <= $#{$matrix->[$i]}; $j++ ) {
            
            if ( defined $matrix->[$i]->[$j] ){
            
                 print "val\t";
                 next;                
            }else{
            
                print "undef\t";
            }
        }
        print "\n";
    }
    
} ## --- end sub show


sub salesman {
    my	( $i )	= @_;
    
    my @result = ();
    my $count = scalar @points;
    push @result, $matrix->[$i]->[0];
    exclude( $matrix, $i );
    while ( $count > 0 ){

        my $min = undef;
        my $next = 0;
        my $j_exclude = 0;

        for ( my $j=1; $j<= scalar @{$matrix->[$i]}; $j++ ) {
        
            if( defined $matrix->[$i]->[$j] && ( !defined $min ||  $min > $matrix->[$i]->[$j]->{VALUE} ) && $matrix->[$i]->[$j]->{STATUS} == 0 ){

                $min = $matrix->[$i]->[$j]->{VALUE};
                $next = $matrix->[0]->[$j];
                $j_exclude = $j;
            }
        }

        last if ( $next == 0 );
        exclude( $matrix, $j_exclude );
        $i = $next;
        $count--;
        push @result,$next;


    }

    return @result;
} ## --- end sub salesman


sub exclude {
    my	( $matrix, $j_exclude )	= @_;

    
    for ( my $i=1; $i <= $#{$matrix}; $i++ ) {

        next unless ( defined $matrix->[$i]->[$j_exclude] );

        
        $matrix->[$i]->[$j_exclude]->{STATUS} = 1;
    }
   
} ## --- end sub exclude



sub calc {
    my	( $p1,$p2 )	= @_;

    my $diff = sqrt( ($p2->{x} - $p1->{x})*($p2->{x} - $p1->{x}) + ($p2->{y} - $p1->{y})* ($p2->{y} - $p1->{y}) );
    return $diff;
} ## --- end sub calc
my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
