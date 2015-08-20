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
	    push @list,[split /\s+\|\s+/, $_];
	}
close $input;


foreach my $arr ( @list ) {
    my $blocksCount = shift @$arr;
    my $word = shift @$arr;
    my @wordLetters = split //,$word;
    my @blocks = split /\s+/,$arr->[0];
    #print Dumper \@words;

    my $blocksHashes = [];
    foreach my $block ( @blocks ) {
        my %blockHash = ();
        my @blockLetters = split //,$block;
        @blockHash{@blockLetters} = (1) x @blockLetters;
        push @$blocksHashes,\%blockHash;
    }
    #print Dumper \$blocksHashes;
    # $DB::single = 2;
    my $wordCanExist = WordExistDeep( \@wordLetters, 0, $blocksHashes );
    if ( $wordCanExist ){
        print "True\n";
    }else{
        print "False\n";
    }
}

sub WordExistDeep {
    my	( $word, $letterForCheckIndex, $blocks )	= @_;

    return 1 if ( $letterForCheckIndex > $#{$word} );

    my @blocks = @$blocks;
    my $wordCanExist = 0;
    my $letter = $word->[$letterForCheckIndex];
    my $countCheckings = 0;

    while ( $countCheckings < scalar @blocks && !$wordCanExist ) {
        my $block = shift @blocks;
        $countCheckings++;
        if ( exists $block->{$letter} ){
            $wordCanExist = WordExistDeep( $word, $letterForCheckIndex + 1, \@blocks );
            push @blocks,$block unless ( $wordCanExist );  
        }else{
            push @blocks,$block;            
        }
    }
    return $wordCanExist;
} ## --- end sub wordExist

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
