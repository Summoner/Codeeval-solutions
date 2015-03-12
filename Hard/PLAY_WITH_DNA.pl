#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper;
use Benchmark;

my $t0 = new Benchmark;

  open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
 #open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";

my $data = [];

	while(<$input>){
    	chomp;
        push @$data,$_;
	}
close $input;

foreach my $part ( @$data ) {

    my ($DNA_segment,$allowed_mismatches,$DNA_string) = ( split /\s+/,$part );

    find_matches( $DNA_segment,$allowed_mismatches,$DNA_string );
}


sub find_matches {
    my ($DNA_segment,$allowed_mismatches,$DNA_string) = @_;

    my $string_length = length $DNA_string;
    my $pattern_length = length $DNA_segment;
    my $i = 0;
    my $result = {};
    my $cashe->{$DNA_segment} = {};

    while( ($string_length - $i) >= $pattern_length ){

        my $main_substr = substr( $DNA_string,$i,$pattern_length );
        my $matching_count = 0;
        unless ( exists $cashe->{$DNA_segment}->{$main_substr} ){

            $matching_count = compare_substrings( $main_substr,$DNA_segment );

            $cashe->{$DNA_segment}->{$main_substr} = $matching_count;

        }else{

            $matching_count = $cashe->{$DNA_segment}->{$main_substr};
        }

        if ( $matching_count <= $allowed_mismatches ){

                push @{ $result->{$matching_count} },$main_substr;
        }
        $i++;
    }
# print Dumper \$result;

#    my @result_arr = ();
#    foreach my $key ( sort { $a <=> $b }keys %{$result} ) {
#
#        push @result_arr, sort { $a cmp $b } @{$result->{$key}}
#    }

#print join " ",@result_arr,"\n";
#print "**********************\n";
    print "No match\n" if ( scalar keys %$result == 0 );
    my @result_arr1 = map { sort {$a cmp $b} @{$result->{$_}} } sort { $a <=> $b }keys %{$result};
    print join " ",@result_arr1,"\n";

} ## --- end sub find_matches


#Return amount of mismatches(levenstein distance)
sub compare_substrings {
    my	( $s,$t )	= @_;

    return 0 if ($s eq $t);
    return length($s) if ( length($t) == 0 );
    return length($t) if ( length($s) == 0 );
    my @s = split //,$s;
    my @t = split //,$t;

    my $matrix = [];
    for ( my $i=0;$i <= length($s);$i++ ) {

        $matrix->[$i]->[0] = $i;
    }
    for ( my $j=0;$j <= length($t);$j++ ) {

        $matrix->[0]->[$j] = $j;
    }

    for ( my $i=0;$i < length($s);$i++ ) {

        for ( my $j=0;$j < length($t);$j++ ) {

            my $cost = ($s[$i] eq $t[$j]) ? 0:1;
            $matrix->[$i+1]->[$j+1] = min( $matrix->[$i]->[$j+1]+1,$matrix->[$i+1]->[$j]+1,$matrix->[$i]->[$j] + $cost );
        }
    }
    return $matrix->[-1]->[-1];
} ## --- end sub compare_substrings


sub min {
    my	@values	= @_;
    my @sorted = sort { $a <=> $b }@values;
    return $sorted[0];
} ## --- end sub min

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
