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
	    push @list,[split //,$_];
	}
close $input;


foreach my $arr ( @list ) {

    calc( $arr );
}


sub calc {
    my	( $arr )	= @_;

    my $size = sqrt scalar @$arr;
    my $matrix = [];

    #Create matrix
    for ( my $i=0; $i < $size; $i++ ) {

        for ( my $j = 0; $j < $size; $j++ ) {

            $matrix->[$i]->[$j] = shift @$arr;
        }
    }
    #Trying to find longest path for each cell of matrix
    my $maxPath = 0;
    for ( my $i=0; $i < $size; $i++ ) {

        for ( my $j = 0; $j < $size; $j++ ) {

            my $storage = [];
            deep( $matrix,$i,$j,{},$storage );
            # my @sorted = sort { $b <=> $a }@$storage;
            #my $currentMaxPath = $sorted[0];
            my $currentMaxPath = $storage->[0];
            if ( $currentMaxPath > $maxPath ){

                $maxPath = $currentMaxPath;
            }
        }
    }
    print "$maxPath\n";
} ## --- end sub calc


sub deep {
    my	( $matrix,$i,$j,$chain,$storage ) = @_;

    return  if ( $i < 0 || $j < 0 || $i > $#{$matrix} || $j > $#{$matrix} );
    return  if exists $chain->{$matrix->[$i]->[$j]};

    $chain->{$matrix->[$i]->[$j]} = 1;

    my %stage = %{$chain};

    #push @$part,$matrix->[$i]->[$j];
    #my @currPart = @$part;
    #my @nextPart = @currPart;
    # print "put $matrix->[$i]->[$j]\n";

    deep( $matrix,$i,$j-1,$chain,$storage );

    #@nextPart = @currPart;
    %{$chain} = %stage;
    deep( $matrix,$i,$j+1,$chain,$storage );

    #@nextPart = @currPart;
    %{$chain} = %stage;
    deep( $matrix,$i-1,$j,$chain,$storage );

    #@nextPart = @currPart;
    %{$chain} = %stage;
    deep( $matrix,$i+1,$j,$chain,$storage );

#      print "Placing in storage: ", join " ",@currPart,"\n";
#    print "    Saved chain: ", join " ",keys %$chain;
#    print "    Saved current chain: ", join " ",keys %stage,"\n";

    # push @$storage,\@currPart;
    # push @$storage, scalar @currPart;
    #push @$storage,scalar keys %stage;
    #
    if ( !defined $storage->[0] || $storage->[0] < scalar keys %stage ){

        $storage->[0] = scalar keys %stage;
    }
} ## --- end sub deep

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
