#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper;
use Benchmark;

my $t0 = new Benchmark;

  open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
#  open my $result, ">/home/fanatic/Summoner/Codeeval-solutions/output1.txt" || die "Can't open file: $!\n";

my @list = ();
my $statusMatch = "Match";
my $statusMisMatch = "Mismatch";
my $statusIndelStart = "Indel start";
my $statusIndelExt = "Indel extention";

	while(<$input>){
    	chomp;
	    push @list,[split /\s+\|\s+/, $_];
	}
close $input;

foreach my $arr ( @list ) {
    print calc( $arr->[0],$arr->[1] ),"\n";
}

sub calc {
    my	( $str1,$str2 )	= @_;
    my @symbols1 = split //,$str1;
    my @symbols2 = split //,$str2;
    my $symbs1Count = scalar @symbols1;
    my $symbs2Count = scalar @symbols2;
    my $maxPoints = 0;
    #my @maxComb = ();

    if ( $symbs1Count == $symbs2Count ){
        for ( my $i = 0; $i <= $#symbols1; $i++ ){
            if ( $symbols1[$i] eq $symbols2[$i] ){
                $maxPoints += 3;
            }else{
                $maxPoints -= 3;
            }
        }
        return $maxPoints;
    }elsif( $symbs1Count > $symbs2Count ){
        my $combsList = [];
        my $comb = [];
        foreach( 0..$#symbols2 ){
            push @$comb,$_;
        }
        while( scalar @$comb != 0 ){
            push @$combsList,$comb;
            $comb = GetNextCombination(scalar @symbols1,scalar @symbols2,$comb);
        }
        $maxPoints = calcPoints( \@symbols1,\@symbols2,$combsList );
        return $maxPoints;
    }elsif( $symbs1Count < $symbs2Count ){
        my $combsList = [];
        my $comb = [];
        foreach( 0..$#symbols1 ){
            push @$comb,$_;
        }
        while( scalar @$comb != 0 ){
            push @$combsList,$comb;
            $comb = GetNextCombination(scalar @symbols2,scalar @symbols1,$comb);
        }
        $maxPoints = calcPoints( \@symbols2,\@symbols1,$combsList );
        return $maxPoints;
    }
} ## --- end sub calc

sub calcPoints {
    my	( $symbols1,$symbols2,$positionsList )	= @_;
    my $maxPoints = undef;
    #   my @solution = ();

    foreach my $positions ( @$positionsList ) {
        my @temp = ();
        for ( my $i = 0; $i <= $#{$positions}; $i++ ) {
            $temp[ $positions->[$i] ] = $symbols2->[$i];
        }
        my $status = "";
        my $points = 0;

        for ( my $i = 0; $i <= $#{$symbols1}; $i++ ) {
            if ( defined $temp[$i] ){
                if ( $symbols1->[$i] eq $temp[$i] ){
                    $status = $statusMatch;
                    $points += 3;
                }else{
                    $status = $statusMisMatch;
                    $points -= 3;
                }
            }else{
                if ( $status eq $statusMatch || $status eq $statusMisMatch || $status eq "" ){
                    $status = $statusIndelStart;
                    $points -= 8;
                }elsif( $status eq $statusIndelStart ){
                    $status = $statusIndelExt;
                    $points -= 1;
                }elsif( $status eq $statusIndelExt ){
                    $points -= 1;
                }
            }
        }
        #print join " ",@$positions,"--->",$points,"\n";
        if ( !defined $maxPoints || $points > $maxPoints ){
            $maxPoints = $points;
            #           @solution = @$positions;
        }
    }
    #print Dumper \@solution;
    return $maxPoints;
} ## --- end sub calcPoints

sub GetNextCombination{
    my ( $n,$k,$combRef ) = @_;
    my $i = $k - 1;
    my $result = [];
    @$result = @$combRef;

    $result->[$i]++;

    while( ($i > 0) && ($result->[$i] >= $n - $k + 1 + $i) ){
	    $i--;
	    $result->[$i]++;
	}
	if ($result->[0] > $n - $k){
	    return $result = [];
	}
	for ( $i = $i +1; $i < $k; $i++ ){
	    $result->[$i] = $result->[$i-1] + 1;
	}
    return $result;
}

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
