#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper;
use Benchmark;
use Clone qw(clone);

my $t0 = new Benchmark;

  open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
  open my $output, ">/home/fanatic/Summoner/Codeeval-solutions/output.txt" || die "Can't open file: $!\n";

my @list = ();

	while(<$input>){
    	chomp;
        $_=~s/\(//g;
        $_=~s/\)//g;
        $_=~s/\s+//g;

	    push @list,[split /,/,$_];
	}
close $input;
#print "***************************************************\n";
#print Dumper \@list;
#print "***************************************************\n";

foreach my $arr_ref ( @list ) {

    proceed( $arr_ref );
}

sub proceed {
    my	( $arr_ref )	= @_;
#$DB::single = 2;
    my $count_ways = 0;
    $count_ways = count_ways( $arr_ref );
#print $count_ways,"\n";
    if ( $count_ways > 0 ){
        # $DB::single = 2;
        my $combinations = count_combinations( $arr_ref );

        #print Dumper \$combinations;
        
        foreach my $combination ( @$combinations ) {

            print "[", join (",",@$combination),"]";
        }
        print "\n";

    }else{

        my $count = 0;
        while ( $count_ways == 0 ){

            $count++;
            $count_ways = count_ways( $arr_ref,$count );        
        }
        print $count,"\n";
    }
} ## --- end sub proceed

sub count_ways {
    my	( $arr_ref, $count )	= @_;

    my @data = @$arr_ref;
    my $oil_amount = pop @data;
       $oil_amount += $count if defined $count;
    my @tankers = sort { $a <=> $b }@data;

    my $matrix_ways = [];
    unshift @tankers,0;

    #matrix initialization
    for ( my $i = 0; $i <= $#tankers; $i++ ) {

        for ( my $j=0; $j <= $oil_amount; $j++ ) {

            $matrix_ways->[$i]->[$j] = 0;
        }
    }

    #matrix fill
    for ( my $i = 1; $i <= $#tankers; $i++ ) {

        for ( my $j=1; $j <= $oil_amount; $j++ ) {

            calc_ways( $matrix_ways,$i,$j,\@tankers );
        }
    }
    return $matrix_ways->[-1]->[-1];
} # --- end sub count_ways

sub count_combinations {
    my	( $arr_ref )	= @_;
#$DB::single = 2;
    my @data = @$arr_ref;
    my $oil_amount = pop @data;

    my @tankers = sort { $a <=> $b }@data;

    my $matrix_combinations = [];
    unshift @tankers,0;

    #matrix initialization
    for ( my $i = 0; $i <= $#tankers; $i++ ) {

        for ( my $j=0; $j <= $oil_amount; $j++ ) {

            $matrix_combinations->[$i]->[$j] = [];
        }
    }

    #matrix fill
    for ( my $i = 1; $i <= $#tankers; $i++ ) {

        for ( my $j=1; $j <= $oil_amount; $j++ ) {

            place_value( $matrix_combinations,$i,$j,\@tankers );
        }
    }
    #$DB::single = 2;
    my $combinations = $matrix_combinations->[-1]->[-1];
    # print Dumper \$combinations;
    my $result = [];
    foreach my $combination ( @$combinations ) {

        my %hash = ();

        foreach my $element ( @$combination ) {

            $hash{$element}++;
        }
        my $result_part = [];
        foreach my $tanker ( @data ) {

            if ( exists $hash{$tanker} ){

                push @$result_part,$hash{$tanker};
            }else{

                push @$result_part,0;
            }
        }
        push @$result,$result_part;
    }
    #return $result;
    #Sorting here
    my $sorted = sort_by_dynamik_criteria( $result,scalar @data );
    # my @sorted = sort { $a->[0] <=> $b->[0] || $a->[1] <=> $b->[1] || $a->[2] <=> $b->[2] } @$result;
    return $sorted;    
} # --- end sub count_ways

sub place_value {
    my	( $matrix_combinations,$i,$j,$tankers )	= @_;

    my $current_tanker = $tankers->[$i];
    my $previous_tanker = $tankers->[$i-1];

    my $current_oil_amount = $j;

    if ( $current_oil_amount < $current_tanker ){

        if ( scalar @{ $matrix_combinations->[$i-1]->[$j] } > 0 ){

            my $combinations = clone $matrix_combinations->[$i-1]->[$j];
               $matrix_combinations->[$i]->[$j] = $combinations;
        }
        #print "i: $i j: $j \n";
        #print Dumper \$matrix_combinations->[$i]->[$j];

    }elsif( $current_oil_amount == $current_tanker ){

        if ( scalar @{ $matrix_combinations->[$i-1]->[$j] } > 0 ){

            my $combinations = clone $matrix_combinations->[$i-1]->[$j];
               $matrix_combinations->[$i]->[$j] = $combinations;
        }

        push @{ $matrix_combinations->[$i]->[$j] }, [ $current_tanker ];
        #print "i: $i j: $j \n";
        #print Dumper \$matrix_combinations->[$i]->[$j] ;

    }elsif( $current_oil_amount > $current_tanker ){

        if ( scalar @{ $matrix_combinations->[$i]->[$j-$current_tanker] } > 0 ){

            my $combinations = clone $matrix_combinations->[$i]->[ $j-$current_tanker ];

            foreach my $combination ( @$combinations ) {

                push @$combination, $current_tanker;
            }
            $matrix_combinations->[$i]->[$j] = $combinations;
        }

        if ( scalar @{ $matrix_combinations->[$i-1]->[$j] } > 0 ){

            my $combinations = clone $matrix_combinations->[$i-1]->[ $j ];
            push @{ $matrix_combinations->[$i]->[$j] }, @$combinations;
        }
        #print "i: $i j: $j \n";
        #print Dumper \$matrix_combinations->[$i]->[$j];
    }
#print Dumper \$matrix_combinations->[$i]->[$j];

} ## --- end sub place_value

sub calc_ways {
    my	( $matrix_ways,$i,$j,$tankers )	= @_;

    my $current_tanker = $tankers->[$i];
    my $current_oil_amount = $j;

    if ( $current_oil_amount < $current_tanker ){

        $matrix_ways->[$i]->[$j] += $matrix_ways->[$i-1]->[$j];

    }elsif( $current_oil_amount == $current_tanker ){

        $matrix_ways->[$i]->[$j] += $matrix_ways->[$i-1]->[$j];
        $matrix_ways->[$i]->[$j]++;

    }elsif( $current_oil_amount > $current_tanker ){

        $matrix_ways->[$i]->[$j] += $matrix_ways->[$i]->[ $j-$current_tanker ];
        $matrix_ways->[$i]->[$j] += $matrix_ways->[$i-1]->[$j];
    }

} ## --- end sub calc_ways


sub sort_by_dynamik_criteria {
    my	( $combinations,$criteria_number )	= @_;
    
    my @sorted = ();
    my @form_sort_stroka = ();
#$DB::single = 2;
    if ( $criteria_number > 1 ){
            
        push @form_sort_stroka,'$a->[0] <=> $b->[0]';
        foreach my $number ( 1..$criteria_number-1 ) {

            push @form_sort_stroka,'||';
            push @form_sort_stroka,create_sort_string($number);    
        }

    }else{
    
        push @form_sort_stroka,'$a->[0] <=> $b->[0]';
    }  
    #print "**************************************************\n";
    my $sort_info = join( " ",@form_sort_stroka);
    @sorted = sort { eval $sort_info }@$combinations;
    return \@sorted;
} ## --- end sub sort_by_dynamik_criteria

sub create_sort_string {
    my	( $number )	= @_;
    return '$a->['.$number.'] <=> $b->['.$number.']';
} ## --- end sub create_sort_string









my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
