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
	    my $temp =  [split /;/,$_];
        shift @$temp;
        $temp->[0] =~ s/:\[/,/g;
        $temp->[0] =~ s/\],*/:/g;
        $temp->[0] =~ s/\s+//g;
        push @list,[split /:/,$temp->[0]];
	}
close $input;

#print Dumper \@list;


foreach my $arr ( @list ) {
my $graph = {};

    foreach my $elem ( @$arr ) {

        my $graph_part = [split /,/,$elem];
        create_graph($graph,$graph_part);
    }
 my ( $initial_matching,$initial_matching_reversed,$unmatched_employees,$unmatched_places ) = find_initial_matching( $graph );
print  max_matching_alg($graph, $initial_matching,$initial_matching_reversed,$unmatched_employees,$unmatched_places ),"\n";
}

sub create_graph {
    my	( $graph,$graph_part )	= @_;

    my $team_member = shift @$graph_part;

    foreach my $office_place ( @$graph_part ) {

        $graph->{$team_member}->{$office_place} = 1;
    }
} ## --- end sub create_graph

sub max_matching_alg {
    my	( $possibility_matching, $initial_matching,$initial_matching_reversed,$unmatched_employees,$unmatched_places ) = @_;

    #We don't have any unmatched employee
    return "Yes" if ( scalar keys %$unmatched_employees == 0 ); 

    my $is_matched = 1;
    my $alternate_path = {};
    foreach my $employee ( keys %{$unmatched_employees} ) {

        #$DB::single = 2;
        $alternate_path = new_path( $employee,$possibility_matching,$initial_matching,$initial_matching_reversed,$unmatched_places,{},{} );

        #If we haven't way to change initial matching between employees and places
        if ( scalar keys %$alternate_path == 0 ){
        
            $is_matched = 0;
            last;
        }

        # print "Alternate path *********************************************\n";
        #print Dumper \$alternate_path;
    
        #print "Merged path ************************************************\n";
        $initial_matching = merge_paths( $initial_matching,$alternate_path );
        $initial_matching_reversed = { reverse %$initial_matching } ;
        #print Dumper \$initial_matching;
    }
    if ( $is_matched ){
    
        return "Yes";
    }else{
    
        return "No";
    }

} ## --- end sub max_matching_alg



sub new_path {
    my	( $start_employee,$possibility_matching,$initial_matching,$initial_matching_reversed,$unmatched_places,$visited_places )	= @_;

    my @places_to_go = keys %{ $possibility_matching->{$start_employee} };
    my $alternate_path_part = {};
    my $local_visited_places = \%{$visited_places};

    foreach my $place ( @places_to_go ) {

        next if ( exists $local_visited_places->{$place} );
        $local_visited_places->{$place} = 1;

        if ( exists $unmatched_places->{$place} ){

            $alternate_path_part->{$start_employee} = $place;
            return $alternate_path_part;
        }
        my $previous_employee = $initial_matching_reversed->{$place};

        my $new_path_part = new_path( $previous_employee,$possibility_matching,$initial_matching,$initial_matching_reversed,$unmatched_places,$local_visited_places );
        if ( scalar keys %$new_path_part > 0 ){

            $alternate_path_part->{$start_employee} = $place;
            return { %$alternate_path_part,%$new_path_part };
        }
    }
   return {};
} ## --- end sub new_path

sub find_initial_matching {
    my	( $possibility_matching )	= @_;

    my $initial_matching = {};
    my $initial_matching_reversed = {};
    my $unmatched_employees = {};
    my $unmatched_places = {};
    my %visited_places = ();
    my %all_places = ();

    foreach my $employee ( keys %$possibility_matching ){

        #If we haven't office places for this employee
        unless ( defined $possibility_matching->{$employee} ){

            $unmatched_employees->{$employee} = 1;
            next;
        }

        #get all office places for this employee
        my @places = keys %{ $possibility_matching->{$employee} };

        #add to all office places and make them uniq
        @all_places{@places} = ();

        foreach my $place ( @places ) {

            #We were not here
            unless ( exists $visited_places{$place} ){

                #One employee -> to one place
                $initial_matching->{$employee} = $place;
                #One place -> to one employee
                $initial_matching_reversed->{$place} = $employee;
                #In purpose not visit this place again
                $visited_places{$place} = 1;
                last;
            }
        }
    }

    #Get all employees, who aren't matched to any place
    foreach my $employee ( keys %{$possibility_matching} ) {

        $unmatched_employees->{$employee} = 1 unless ( exists $initial_matching->{$employee} );
    }
    #Get all places that aren't matched any employee
    foreach my $place ( keys %all_places ) {

        $unmatched_places->{$place} = 1 unless ( exists $visited_places{$place} );
    }

    #print "Possibility matching *****************************************\n";
    #print Dumper \$possibility_matching;
    #print "Initial matching *********************************************\n";
    #print Dumper \$initial_matching;
    #print "remained employees *******************************************\n";
    #print Dumper \$unmatched_employees;
    #print "remained places **********************************************\n";
    #print Dumper \$unmatched_places;
    #print "**************************************************************\n";

    return ( $initial_matching,$initial_matching_reversed,$unmatched_employees,$unmatched_places );
} ## --- end sub find_initial_matching


sub merge_paths {
    my	( $initial_path,$suggested_path )	= @_;

    
#    foreach my $employee ( keys %$suggested_path ) {

    #       next unless ( exists $initial_path->{$employee} );
    #   $initial_path->{$employee} = $suggested_path->{$employee};
#    }

    return { %$initial_path,%$suggested_path };
} ## --- end sub merge_paths
my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
