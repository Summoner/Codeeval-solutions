#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper;
use Benchmark;

my $t0 = new Benchmark;

  open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input1.txt" || die "Can't open file: $!\n";
 #open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";

my @list = ();

	while(<$input>){
    	chomp;
	    push @list,[split /\s+/,$_];
	}
close $input;

foreach my $arr ( @list ) {

    #print $arr->[0];
    #print " ";
    #print $arr->[1];
    #print "\n";
    print calc1( $arr->[0],$arr->[1] );
}

sub calc1 {
    my	( $dSequence,$lSequence )	= @_;

    my @digits = split //,$dSequence;
    my @letters = split //,$lSequence;

    return "No\n" if ( scalar @letters < scalar @digits );
    return "No\n" if ( $digits[0] == 0 && $letters[0] eq 'B' );
    my $matrix = [];
    $matrix->[0]->[0] = 1;

    for ( my $j = 1; $j < scalar @letters; $j++ ) {

        if ( ( $letters[$j-1] eq $letters[$j] ) && ( $matrix->[0]->[$j-1] == 1 ) ){

            $matrix->[0]->[$j] = 1;

        }else{

            $matrix->[0]->[$j] = 0;
        }
    }

    for ( my $i = 1; $i < scalar @digits; $i++ ) {

        for ( my $j = $i; $j < scalar @letters; $j++ ) {

            if ( $matrix->[$i-1]->[$j-1] ){

                if ( ($digits[$i] == 0 && $letters[$j] eq 'A' ) || ($digits[$i] == 1) ){

                    $matrix->[$i]->[$j] = 1;
                }
            }else{

                if ( ($matrix->[$i]->[$j-1]) && ($letters[$j-1] eq $letters[$j]) ){

                    $matrix->[$i]->[$j] = 1;
                }
            }
        }
    }

    return "Yes\n" if ( $matrix->[-1]->[-1] );
    return "No\n";

} ## --- end sub calc1


sub calc {
    my	( $dSequence,$lSequence )	= @_;

    my @digits = split //,$dSequence;
    my @letters = split //,$lSequence;
    #Create matrix with undef elements
    my $matrix = [];

    for ( my $i = 0; $i < length($dSequence);$i++ ) {

        for ( my $j=0; $j< length($lSequence); $j++ ) {

            $matrix->[$i]->[$j] = undef;
        }
    }
    matchingProcess(\@digits,\@letters,$matrix,0,0);

    return "Yes\n" if ( $matrix->[-1]->[-1] );
    return "No\n";

} ## --- end sub calc


sub matchingProcess {
    my	( $digits,$letters,$matrix,$row,$col )	= @_;

    return if ( $matrix->[-1]->[-1] );
    return if ( $row >= scalar @$digits || $col >= scalar @$letters );
    return if ( $matrix->[$row]->[$col] );
    my @tempLetters = @$letters;

    for ( my $j = $col; $j < scalar @$letters; $j++ ) {

        my @temp = @tempLetters[$col..$j];
        if ( matching( $digits->[$row], \@temp ) ){

            $matrix->[$row]->[$j] = 1;
            matchingProcess( $digits,$letters,$matrix,$row+1,$j+1 );
        }
    }
}## --- end sub matchingProcess

sub matching {
    my	( $digit,$letters )	= @_;

    my %hash = ();

    foreach my $letter ( @$letters ) {

        $hash{$letter}++;
    }

    if ( defined $hash{"B"} ){

        if ( $digit == 0 ){

            return 0;
        }else{

            if ( defined $hash{"A"} ){

                return 0;
            }
        }
    }
    return 1;
} ## --- end sub matching



my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
