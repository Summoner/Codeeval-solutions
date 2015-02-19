#!/usr/bin/perl -w
package Circuit;

sub new {
    my $class = shift;
    my $self = {@_};
    bless $self,$class;
    return $self;
} ## --- end sub new

sub H {
    $_[0]->{H} = $_[1] if exists $_[1]; $_[0]->{H};
} ## --- end sub H

sub E {
    $_[0]->{E} = $_[1] if exists $_[1]; $_[0]->{E};
} ## --- end sub E

sub P {
    $_[0]->{P} = $_[1] if exists $_[1]; $_[0]->{P};
} ## --- end sub P

1;

package Juggler;

sub new {
    my $class = shift;
    my $self = {@_};
    bless $self,$class;
    return $self;
} ## --- end sub new

sub H {
    $_[0]->{H} = $_[1] if exists $_[1]; $_[0]->{H};
} ## --- end sub H

sub E {
    $_[0]->{E} = $_[1] if exists $_[1]; $_[0]->{E};
} ## --- end sub E

sub P {
    $_[0]->{P} = $_[1] if exists $_[1]; $_[0]->{P};
} ## --- end sub P

1;

package Process;

sub new {
    my $class = shift;
    my $self = {};
    bless $self,$class;
    return $self;
} ## --- end sub new


sub calc_assigment {
    my	( $self,$circuit,$juggler )	= @_;

    my $assigment_level = ( $circuit->H * $juggler->H + $circuit->P * $juggler->P + $circuit->E * $juggler->E );
    return $assigment_level;
} ## --- end sub calc_assigment


sub form_assigment {
    my ($self,$jugglers,$circuits) = @_;

    my $assigments = {};
    foreach my $circuit ( keys %$circuits ) {

        foreach my $juggler ( keys %$jugglers ) {

           my $assigment =  $self->calc_assigment( $circuits->{$circuit},$jugglers->{$juggler} );
              $assigments->{$juggler}->{$circuit} = $assigment;
        }
    }
    return $assigments;
} ## --- end sub form_assigment
1;
use strict;
use warnings;
use Data::Dumper;
use Benchmark;

my $t0 = new Benchmark;

  open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
 #open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";

my @circuit_data = ();
my @jugglers_data = ();

	while(<$input>){
    	chomp;
        if ( $_ =~ /^C/ ){

            push @circuit_data,[split /\s+/,$_];

        }elsif( $_ eq "" ){

            next;

        }elsif( $_ =~ /^J/ ){

            push @jugglers_data,[split /\s+/,$_];
        }	    
	}
close $input;

my $assigned_jugglesrs = scalar @circuit_data / scalar @jugglers_data;
my $circuits = {};

foreach my $circuit ( @circuit_data ) {

    shift @$circuit;
    #get C1 or C2 value
    my $circuit_name = shift @$circuit;
    #get H E P values
    my ( $H, $H_val ) = split /:/,$circuit->[0];
    my ( $E, $E_val ) = split /:/,$circuit->[1];
    my ( $P, $P_val ) = split /:/,$circuit->[2];

    my $circ = Circuit->new( ($H,$H_val,$E,$E_val,$P,$P_val) );
    $circuits->{$circuit_name} = $circ;
}

#print Dumper \$circuits;

my $jugglers = {};
my $juggler_to_circuits = {};
foreach my $juggler ( @jugglers_data ) {

    shift @$juggler;
    #get J1 or J2 or another value
    my $juggler_name = shift @$juggler;
    #get H E P values
    my ( $H, $H_val ) = split /:/,shift @$juggler;
    my ( $E, $E_val ) = split /:/,shift @$juggler;
    my ( $P, $P_val ) = split /:/,shift @$juggler;

    my $jugg = Juggler->new( ($H,$H_val,$E,$E_val,$P,$P_val) );
    $jugglers->{$juggler_name} = $jugg;

    $juggler_to_circuits->{$juggler_name} = [split /,/,shift @$juggler];
}

#print Dumper \$jugglers;

my $p = Process->new();
#$DB::single = 2;
my $assigments = $p->form_assigment( $jugglers,$circuits );

print Dumper \$assigments;

print Dumper \$juggler_to_circuits;

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
