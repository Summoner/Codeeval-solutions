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

my $matrix = [];
foreach my $arr ( @list ) {

    calc( $matrix,$arr );
    show_matrix($matrix);

}



sub calc {
    my	( $matrix,$arr )	= @_;

    while ( scalar @$arr > 0 ){

        my $temp = [];
        for ( my $i = 0; $i < 10; $i++)  {

            push @$temp, shift @$arr;
        }
        push @$matrix,$temp;
    }

    my $changes = 1;

    while ( $changes > 0 ){

        for ( my $i = 1; $i < 9; $i++ ) {

            for ( my $j = 1; $j < 9; $j++ ) {

                if ( $matrix->[$i]->[$j] eq "*" || $matrix->[$i]->[$j] eq "// " || $matrix->[$i]->[$j] eq "\\" ){

                    changes( $matrix,$i,$j );

                }else{

                    if ( $matrix->[$i-1]->[$j-1] eq "\\" || $matrix->[$i+1]->[$j+1] eq "\\" ){

                        $matrix->[$i]->[$j] = "\\";

                    }elsif( $matrix->[$i-1]->[$j+1] eq "//" || $matrix->[$i+1]->[$j-1] eq "//" ){

                        $matrix->[$i]->[$j] = "//";
                    }
                }
            }
        }
    }
} ## --- end sub calc


sub changes {
    my	( $matrix, $row,$column )	= @_;

        if ( $matrix->[$row]->[$column] eq "*" ){

            if ( $matrix->[$row-1]->[$column-1] eq "\\" || $matrix->[$row+1]->[$column+1] eq "\\" ||
                 $matrix->[$row-1]->[$column+1] eq "//" || $matrix->[$row+1]->[$column-1] eq "//" ){

                $matrix->[$row+1]->[$column+1] = "\\";
                $matrix->[$row-1]->[$column-1] = "\\";
                $matrix->[$row+1]->[$column-1] = "//";
                $matrix->[$row-1]->[$column+1] = "//";
            }

        }elsif( $matrix->[$row]->[$column] eq "\\" ){

            if ( $matrix->[$row-1]->[$column-1] eq "\\" ){

                 $matrix->[$row+1]->[$column+1] = "\\";

            }elsif( $matrix->[$row-1]->[$column-1] eq "#" && $row != 0 && $column != 0 )


        }
    return ;
} ## --- end sub changes

sub show_matrix {
    my	( $matrix )	= @_;

    for ( my $i = 0;$i < scalar @$matrix; $i++ ) {

        for ( my $j = 0; $j < scalar @{$matrix->[$i]}; $j++ ) {

            print "$matrix->[$i]->[$j]";
        }
        print "\n";
    }
    return ;
} ## --- end sub show_matrix
my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
