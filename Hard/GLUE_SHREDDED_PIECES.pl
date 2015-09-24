#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper;
use Benchmark;
use Storable qw (dclone);

my $t0 = new Benchmark;

open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
# open my $result, ">/home/fanatic/Summoner/Codeeval-solutions/output.txt" || die "Can't open file: $!\n";

my @list = ();

	while(<$input>){
    	chomp;
	    push @list,[split /\|/,$_];
	}
close $input;

foreach my $words ( @list ) {

    shift @$words;
    my $wordLength = length( $words->[0] );
    my $wordsAmount = scalar @$words;
    my $textLength = $wordsAmount + $wordLength - 1;
    my $formedString = undef;
    my $cash = {};
#    print Dumper \$words;
    CreateCash( $words,$cash );
#    print Dumper \$cash;
    for ( my $i = 0; $i <= $#{ $words }; $i++ ){

        my $startWord = $words->[$i];
        $formedString = $startWord;
        $formedString = Deep( $startWord, $formedString, $textLength, $cash );

        last if ( defined $formedString );
    }
    print "$formedString\n";
}

sub Deep {
    my	( $previousWord,$formedString,$textLength,$cash )	= @_;

    if ( length($formedString) == $textLength ){

        return $formedString;
    }

    return undef unless defined $cash->{ $previousWord };
    my @currentWords = @{ $cash->{ $previousWord } };
    my $currentCash = dclone( $cash );
    delete $currentCash->{ $previousWord };

    my $currentFormedString = $formedString;

    foreach my $word ( @currentWords ) {

        my $lastSymbol = substr( $word, -1 );
        $currentFormedString = $formedString . $lastSymbol;
        $currentFormedString = Deep( $word, $currentFormedString, $textLength,$currentCash );
        return $currentFormedString if ( defined $currentFormedString );
    }
    return undef;
} ## --- end sub Deep

sub CreateCash {
    my	( $words,$cash )	= @_;

    for ( my $i = 0; $i < $#{ $words }; $i++ ) {
        my $word1 = $words->[$i];
        my $pattern1 = substr( $word1, -(length( $word1 ) - 1) );

        for ( my $j = $i +1; $j <= $#{ $words }; $j++ ) {
            my $word2 = $words->[$j];
            my $pattern2 = substr( $word2, -(length( $word2 ) - 1) );

            if ( $word2 =~ /^\Q$pattern1\E.{1}$/ ){

                push @{ $cash->{$word1} },$word2;

            }elsif( $word1 =~ /^\Q$pattern2\E.{1}/ ){

                push @{ $cash->{$word2} },$word1;

            }
        }
    }
} ## --- end sub CreateCash



my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "All the code took:",timestr($td),"\n";
