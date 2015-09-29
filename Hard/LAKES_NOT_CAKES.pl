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
	    push @list,[split /\s+\|\s+/,$_];
	}
close $input;

foreach my $arr ( @list ) {

    my $matrix = FormMatrix( $arr );
    #print Dumper \$matrix;
    CalcLakes( $matrix );
}

sub FormMatrix {
    my	( $arr )	= @_;
    my $matrix = [];
    foreach my $str ( @$arr ) {
        push @$matrix, [ split /\s+/,$str ];
    }
    return $matrix;
} ## --- end sub FormMatrix

sub CalcLakes {
    my	( $matrix )	= @_;

    my $lakesCount = 0;

    for ( my $i = 0; $i <= $#{ $matrix }; $i++ ) {

        for ( my $j = 0; $j <= $#{ $matrix->[$i] }; $j++ ) {
                $lakesCount += Deep( $matrix, $i,$j );
        }
    }
    
    print "$lakesCount\n"; ;
} ## --- end sub CalcLakes

sub Deep {
    my	( $matrix,$i,$j )	= @_;
    
    return if ( $i < 0 || $j < 0 || $i > $#{ $matrix } || $j > $#{ $matrix->[$i] } );

    my $lakeExist = 0;
    if ( $matrix->[$i]->[$j] eq "o" ){

        my $lakeExist = 1;
        $matrix->[$i]->[$j] = "*";

        Deep( $matrix,$i+1,$j );
        Deep( $matrix,$i-1,$j );
        Deep( $matrix,$i,$j+1 );
        Deep( $matrix,$i,$j-1 );
        Deep( $matrix,$i+1,$j+1 );
        Deep( $matrix,$i-1,$j-1 );
        Deep( $matrix,$i+1,$j-1 );
        Deep( $matrix,$i-1,$j+1 );

        return $lakeExist;
    }else{
        return $lakeExist;
    }
} ## --- end sub Deep


my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
