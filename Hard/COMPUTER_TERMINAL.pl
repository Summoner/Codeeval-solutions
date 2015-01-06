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

my $insert_mode = 0;
my $overwrite_mode = 1;
my $matrix = [];
my $i = 0;
my $j = 0;

foreach my $arr (@list){

    #$i = 0;
    #$j = 0;
   calc($arr);
}
show_matrix($matrix);

sub calc {
    my	( $arr )	= @_;

    while ( scalar @$arr > 0 ){

        if ( $arr->[0] eq "^" && $arr->[1] =~ /\d/ &&  $arr->[2] =~ /\d/ ){

            $i = $arr->[1];
            $j = $arr->[2];
            splice ( @$arr,0,3);

        }elsif( $arr->[0] eq "^" && $arr->[1] eq "c" ) {

            clear_matrix($matrix);
            splice ( @$arr,0,2);

        }elsif( $arr->[0] eq "^" && $arr->[1] eq "h" ) {

            $i = 0;
            $j = 0;
            splice ( @$arr,0,2);

        }elsif( $arr->[0] eq "^" && $arr->[1] eq "b" ) {

            $j = 0;
            splice ( @$arr,0,2);

        }elsif( $arr->[0] eq "^" && $arr->[1] eq "d" ) {

            $i++ if ( $i < 9 );
            splice ( @$arr,0,2);

        }elsif( $arr->[0] eq "^" && $arr->[1] eq "u" ) {

            $i-- if ( $i > 0 );
            splice ( @$arr,0,2);

        }elsif( $arr->[0] eq "^" && $arr->[1] eq "l" ) {

            $j-- if ( $j > 0 );
            splice ( @$arr,0,2);

        }elsif( $arr->[0] eq "^" && $arr->[1] eq "r" ) {

            $j++ if ( $j < 9 );
            splice ( @$arr,0,2);

        }elsif( $arr->[0] eq "^" && $arr->[1] eq "e" ) {

            erase_row($matrix,$i,$j);
            splice ( @$arr,0,2);

        }elsif( $arr->[0] eq "^" && $arr->[1]  eq "i" ) {

            $insert_mode = 1;
            $overwrite_mode = 0;
            splice ( @$arr,0,2);

        }elsif( $arr->[0] eq "^" && $arr->[1] eq "o" ) {

            $insert_mode = 0;
            $overwrite_mode = 1;
            splice ( @$arr,0,2);

        }elsif( $arr->[0] eq "^" && $arr->[1] eq "^" ) {

           if ( $overwrite_mode == 1 ){

                $matrix->[$i]->[$j] = $arr->[1];

            }elsif( $insert_mode == 1 ){

                shift_row($matrix,$i,$j);
                $matrix->[$i]->[$j] = $arr->[1];
                
            }

            $j++ if ( $j < 9 );
            splice ( @$arr,0,2);

        }elsif( $arr->[0] ne "^" && $overwrite_mode == 1 ) {

            $matrix->[$i]->[$j] = $arr->[0];
            $j++ if ( $j < 9 );
            splice ( @$arr,0,1);

        }elsif( $arr->[0] ne "^" && $insert_mode == 1 ) {

            shift_row($matrix,$i,$j);
            $matrix->[$i]->[$j] = $arr->[0];
            $j++ if ( $j < 9 );
            splice ( @$arr,0,1);
        }
    }

} ## --- end sub calc

sub show_matrix {
    my	( $matrix )	= @_;

    for ( my $i=0;$i < 10; $i++ ) {

        for ( my $j=0;$j < 10; $j++ ) {

            print $matrix->[$i]->[$j];
        }
        print "\n";
    }
} ## --- end sub clear_matrix


sub shift_row {
    my	( $matrix,$i,$j )	= @_;

    for ( my $k = 9; $k > $j; $k-- ) {
        $matrix->[$i]->[$k] = $matrix->[$i]->[$k-1];
    }

} ## --- end sub shift_row

sub erase_row {
    my	( $matrix, $i,$j )	= @_;

    for ( my $k = $j; $k < 10; $k++ ) {

        $matrix->[$i]->[$k] = "";
    }

} ## --- end sub erase_row

sub clear_matrix {
    my	( $matrix )	= @_;

    for ( my $i=0;$i < 10; $i++ ) {

        for ( my $j=0;$j < 10; $j++ ) {

            $matrix->[$i]->[$j] = " ";
        }
    }
} ## --- end sub clear_matrix
my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
