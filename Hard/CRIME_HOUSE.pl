#!/usr/bin/perl -w
use strict;
use warnings;


package Criminal;


sub new {
    my $class = shift;
    my $self = { @_ };
    bless $self,$class;
    return $self;
} ## --- end sub new


sub status {

    $_[0]->{status} = $_[1] if defined $_[1];$_[0]->{status};
} ## --- end sub status

sub id {

    $_[0]->{id} = $_[1] if defined $_[1];$_[0]->{id};
} ## --- end sub status


package CriminalHouse;

sub new {
    my $class = shift;
    my $self = { @_ };
    bless $self,$class;
    return $self;
} ## --- end sub new

my $_house = {};
my $_street = {};


sub clearHouseandStreet {
    my	( $self )	= @_;
    $_house = {};
    $_street = {};
} ## --- end sub clearHouseandStreet

sub error {

    $_[0]->{error} = $_[1] if defined $_[1];$_[0]->{error};
} ## --- end sub error

sub door {
    #$DB::single = 2;
    my $self = shift;
    my $criminal = shift;
    my $id = $criminal->id;

    #Guy in mask
    if ( $id == 0 ){
#    $DB::single = 2;
        #He is trying to go in house
        if ( $criminal->status eq "in" ){

            #So we put him there
            push @{ $_house->{$id} },$criminal;
            shift @{ $_street->{$id} };

            #But we don't know who hi is
            foreach my $otherCriminal ( values %{$_street} ) {

                next unless ( ref $otherCriminal eq "Criminal");
                $otherCriminal->status("unknown");
            }

         #He is trying to go out from house
        }elsif( $criminal->status eq "out" ){

            #So put him on the street
            push @{ $_street->{$id} },$criminal;
            shift @{ $_house->{$id} };

            #We don't know who left the house
            foreach my $otherCriminal ( values %{$_house} ) {

                next unless ( ref $otherCriminal eq "Criminal");
                $otherCriminal->status("unknown");
            }
        }

    #Guy without mask
    }else{

        #Trying to get in
        if ( $criminal->status eq "in" ){

            #If we know who he is
            if ( exists $_street->{$id} ){

                #get him out from street
                delete $_street->{$id};
            }else{

                #else decrement amount guys in masks in the street
                shift @{ $_street->{0} };
            }
            #And put this guy in house
            #but before put him into the house
            #We need to check if he already marked as "in" guy
            #because if he is - it means another door into the house exist
            $self->error("CRIME TIME") if ( defined $_house->{$id} && $_house->{$id}->{status} eq "in" );
            $_house->{$id} = $criminal;

        #Trying to get out from house
        }elsif( $criminal->status eq "out" ){

            #If we know who he is
            if ( exists $_house->{$id} ){

                #Get him out from house
                delete $_house->{$id};

            }else{

                #decrement amount of guys in masks in house
                shift @{ $_house->{0} };
            }
            #Before put him into the street
            #We need to check if he already marked as "out" guy
            #because if he is - it means another door into the house exist
            $self->error("CRIME TIME") if ( defined $_street->{$id} && $_street->{$id}->{status} eq "out" );
            $_street->{$id} = $criminal;
        }
    }
} ## --- end sub status

sub criminalsInHouseCount {

    my $count = 0;
    if ( defined $_house->{0} ){

        $count += scalar @{ $_house->{0} };
        $count += scalar keys %$_house;
        $count--;

    }else{

        $count += scalar keys %$_house;
    }
    return $count;
} ## --- end sub status

use Benchmark;
use Data::Dumper;
my $t0 = new Benchmark;

  open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
 #open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";

my @list = ();

	while(<$input>){
    	chomp;
	    push @list,[split /;\s+/, $_];
	}
close $input;

foreach my $arr ( @list ) {

    calc( $arr );
}


sub calc {
    my	( $arr )	= @_;
    my $movesCount = $arr->[0];
    my @moves = split /\|/,$arr->[1];
    my $house = CriminalHouse->new();

    foreach my $move ( @moves ) {

        my ( $direction,$id ) = split /\s+/,$move;

        my $criminal = Criminal->new( "id",$id );
        if ( $direction eq "E" ){

            $criminal->status("in");

        }elsif( $direction eq "L" ){

            $criminal->status("out");
        }

        $house->door($criminal);
    }
    if ( defined $house->error && $house->error eq "CRIME TIME" ){

        print $house->error,"\n";

    }else{

        print $house->criminalsInHouseCount,"\n";
    }
    #print "In the street: ",$house->criminalsInTheStreetCount,"\n";
    $house->clearHouseandStreet();
} ## --- end sub calc

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
