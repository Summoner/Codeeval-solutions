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
	    push @list,[split /;/, $_];
	}
close $input;

foreach my $arr ( @list ) {

    my @customers = split /,/,$arr->[0];
    my @products = split /,/,$arr->[1];

    my $ss_table = calc_SS( \@customers,\@products );
    #$DB::single = 2;
    my $biggest_ss = biggest_SS( $ss_table );
    printf "%.2f\n",$biggest_ss;
}

sub biggest_SS {
    my	( $ss_table )	= @_;
    # print "1--ss_table---------------------------------------------\n";
    # print Dumper \$ss_table;

    if ( scalar @$ss_table > 1 ){

        if ( scalar @{$ss_table->[0]} > 1 ){

            my @delta_sses = map { my @products_sses = @$_;
                                   my $first_product_ss = $products_sses[0];
                                   my $other_products_ss_max = get_max( @products_sses[1..$#products_sses] );
                                   my $delta_ss = $first_product_ss - $other_products_ss_max;
            }@$ss_table;

            # print "2--delta_sses----------------------------------------------\n";
            # print join " ",@delta_sses,"\n";
            my $max_delta_ss = get_max( @delta_sses );
            my @max_delta_ss_customers_is = grep{$delta_sses[$_] == $max_delta_ss }0..$#delta_sses;

            #print "3-max_delta_ss_customers_is---------------------------------------------\n";
            #print  join " ",@max_delta_ss_customers_is,"\n";
            my @summs = ();
            #$DB::single = 2;
            foreach my $max_delta_ss_customers_i( @max_delta_ss_customers_is ) {

                my $remaining_ss_table = [];

                foreach my $customer_i ( 0..$#{$ss_table} ) {

                    next if ( $customer_i == $max_delta_ss_customers_i );

                    my @remaining_part = @{$ss_table->[$customer_i]};
                    shift @remaining_part;
                    push @$remaining_ss_table,\@remaining_part;
                }
                my $res = $ss_table->[$max_delta_ss_customers_i]->[0] + biggest_SS( $remaining_ss_table );
                push @summs,$res;
            }

            # print "3----------------------------------------------\n";
             #get_max here
             return get_max( @summs );
        }else{
            #$DB::single = 2;
            #print "last part here--------------------------------------------------\n";
            my $transposed = transpose( $ss_table );
            my $last_part = get_max(@$transposed );
            #print "$last_part\n";
            return $last_part;
        }
    }else{

        # print "last part -------------------------------------------------\n";
        #print "$ss_table->[0]->[0]\n";
        return $ss_table->[0]->[0];
    }
} ## --- end sub biggest_SS

sub get_max {
    my	( @values )	= @_;

    my @sorted_values = sort { $b <=> $a }@values;
    return $sorted_values[0];
} ## --- end sub get_max

sub transpose {
    my	( $matrix )	= @_;

    my $result = [];
    my $rows = scalar @$matrix;
    my $columns = scalar @{$matrix->[0]};

    my $transposed_rows = $columns;
    my $transposed_columns = $rows;


    for ( my $i=0; $i < $transposed_rows; $i++ ) {

        for ( my $j=0; $j < $transposed_columns; $j++ ) {

            $result->[$i]->[$j] = $matrix->[$j]->[$i];
        }
    }
    return $result->[0];
} ## --- end sub transpose

sub calc_SS {
    my	( $customers,$products )	= @_;

    my $results = [];

    foreach my $customer ( @$customers ) {

        my $max = 0;
        my $c_letters = count_letters( $customer );
        my $result = [];
        foreach my $product ( @$products ) {

            my $SS = 0;
            my $p_letters = count_letters( $product );

            if ( $p_letters % 2 == 0 ){

                $SS = count_vowels( $customer ) * 1.5;

            }elsif( $p_letters % 2 != 0 ){

                $SS = count_consonants( $customer );
            }

            if ( GCD( $c_letters,$p_letters ) != 1 ){

                $SS = $SS * 1.5;
            }
            push @$result, $SS;
        }
        push @$results, $result;
    }
    #print Dumper \$results;
    return $results;
} ## --- end sub calc

sub count_consonants {
    my	( $word )	= @_;

    $word =~ s/[^A-Za-z]//g;
    my @letters = split //,$word;
    my %vowels = ();
    $vowels{a} = 1;
    $vowels{e} = 1;
    $vowels{i} = 1;
    $vowels{o} = 1;
    $vowels{y} = 1;
    $vowels{u} = 1;

    my $count = 0;
    foreach my $letter ( @letters ) {

        $count++ unless ( exists $vowels{lc($letter)} );
    }
     return $count;
} ## --- end sub count_consonants

sub count_vowels {
    my	( $word )	= @_;

    $word =~ s/[^A-Za-z]//g;
    my @letters = split //,$word;
    my %vowels = ();
    $vowels{a} = 1;
    $vowels{e} = 1;
    $vowels{i} = 1;
    $vowels{o} = 1;
    $vowels{y} = 1;
    $vowels{u} = 1;

    my $count = 0;
    foreach my $letter ( @letters ) {

        $count++ if ( exists $vowels{lc($letter)} );
    }
    return $count;
} ## --- end sub count_vowels

sub count_letters {
    my	( $word )	= @_;

    $word =~ s/[^A-Za-z]//g;
    my @count = split //,$word;
    my %hash = ();

    foreach my $letter ( @count ) {
        $hash{lc($letter)}++;
    }
    return scalar @count;
} ## --- end sub count_letters

sub GCD {
    my	( $a,$b )	= @_;

    return $b == 0 ? $a : GCD( $b, $a % $b );
} ## --- end sub GCD

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
