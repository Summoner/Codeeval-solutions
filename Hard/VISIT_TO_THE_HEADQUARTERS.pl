#!/usr/bin/perl -w

package Constants;

sub alphabetCodes {
    my	( $class,$symbol )	= @_;
    my %alphabet = ();

    $alphabet{A} = 1;
    $alphabet{B} = 2;
    $alphabet{C} = 3;
    $alphabet{D} = 4;
    $alphabet{E} = 5;
    $alphabet{F} = 6;
    $alphabet{G} = 7;
    $alphabet{H} = 8;
    $alphabet{I} = 9;
    $alphabet{J} = 10;
    $alphabet{K} = 11;
    $alphabet{L} = 12;
    $alphabet{M} = 13;
    $alphabet{N} = 14;
    $alphabet{O} = 15;
    $alphabet{P} = 16;
    $alphabet{Q} = 17;
    $alphabet{R} = 18;
    $alphabet{S} = 19;
    $alphabet{T} = 20;
    $alphabet{U} = 21;
    $alphabet{V} = 22;
    $alphabet{W} = 23;
    $alphabet{X} = 24;
    $alphabet{Y} = 25;
    $alphabet{Z} = 26;

    return $alphabet{$symbol};
} ## --- end sub alphabetCodes

sub convertTime {
    my	( $class,$timeStr )	= @_;

    my $h = 0;
    my $m = 0;
    my $s = 0;
    $h += int( $timeStr / 3600);
    my $rem = $timeStr % 3600;

    $m += int( $rem / 60 ) if ( $rem > 0 );
    if ( $rem % 60 > 0 ){
        $s += $rem % 60;
    }
    $h = sprintf("%02d",$h);
    $m = sprintf("%02d",$m);
    $s = sprintf("%02d",$s);

    return join ":",($h,$m,$s);
} ## --- end sub convertTime

#Statues of agents
sub justEnter {
    my	( $class )	= @_;
    return 1;
} ## --- end sub justEnter

sub toElevator {
    my	( $class )	= @_;
    return 2;
} ## --- end sub toElevator

sub toRoom {
    my	( $class )	= @_;
    return 3;
} ## --- end sub toRoom

sub inQueueToRoom {
    my	( $class )	= @_;
    return 4;
} ## --- end sub inQueueToRoom

sub inQueueToElevator {
    my	( $class )	= @_;
    return 5;
} ## --- end sub inQueueToElevator

sub inElevator {
    my	( $class )	= @_;
    return 6;
} ## --- end sub inElevator

sub toExit {
    my	( $class )	= @_;
    return 7;
} ## --- end sub toExit

sub inRoom {
    my	( $class )	= @_;
    return 8;
} ## --- end sub inRoom


package Building;

sub new {
    my $class = shift;
    my $self = {@_};

    bless $self,$class;
    return $self;
} ## --- end sub new

sub busy {
    $_[0]->{busy} = $_[1] if defined $_[1];return $_[0]->{busy};
} ## --- end sub busy

sub setAgentToQueue {
    my ($self,$agent) = @_;
    push @{$self->{queue}},$agent if (defined $agent);
    return $self;
} ## --- end sub setAgentToQueue

sub getAgentFromQueue {
    my ($self) = @_;
    return shift @{$self->{queue}} if ( scalar @{$self->{queue}} > 0 );
} ## --- end sub getAgentFromQueue

sub queue {
    $_[0]->{queue} = $_[1] if defined $_[1];return $_[0]->{queue};
} ## --- end sub getQueue

sub getQueueCount {
    return scalar @{$_[0]->{queue}};
} ## --- end sub getQueueCount

sub sortQueue{
    my ( $self ) = ( @_ );
    my @sortedAgents = sort { $a->rating <=> $b->rating } @{$self->queue};
    return $self->queue(\@sortedAgents);
} ## --- end sub sortQueue


package Agent;

sub new {
    my $class = shift;
    my $self = {@_};
    bless $self,$class;
    return $self;
} ## --- end sub new

sub rating {
    my	( $self,$code )	= @_;
    return $self->{rating} unless defined $code;
    return $self->{rating} = Constants->alphabetCodes( $code );
} ## --- end sub rating

sub entryTime {
    my	( $self,$dateTimeStr )	= @_;
    return $self->{entryTime} unless defined $dateTimeStr;
    my ( $hour,$min,$sec ) = split /:/,$dateTimeStr;
    my $timeInSec = $hour * 3600 + $min * 60 + $sec;
    return $self->{entryTime} = $timeInSec;
} ## --- end sub entryDate

sub exitTime {
    $_[0]->{exitTime} = $_[1] if defined $_[1];return $_[0]->{exitTime};
} ## --- end sub exitTime

sub passedTime {
    $_[0]->{passedTime} = $_[1] if defined $_[1];return $_[0]->{passedTime};
} ## --- end sub exitTime

sub waitingTime {
    my ( $self,$timeVal ) = @_;
    if( !defined $self->{waitingTime} || $self->{waitingTime} < 0 ){
        $self->{waitingTime} = 0;
    }
    if ( defined $timeVal ){
        $self->{waitingTime} = $timeVal;
    }else{
        return $self->{waitingTime};
    }
} ## --- end sub waitingTime

sub status {
    $_[0]->{status} = $_[1] if defined $_[1];return $_[0]->{status};
} ## --- end sub status

sub route {
    $_[0]->{route} = $_[1] if defined $_[1];return $_[0]->{route};
} ## --- end sub route

sub currentFloor {
    $_[0]->{currentFloor} = $_[1] if defined $_[1];return $_[0]->{currentFloor};
} ## --- end sub route

sub currentRoom {
    $_[0]->{currentRoom} = $_[1] if defined $_[1];return $_[0]->{currentRoom};
} ## --- end sub route

sub remainedRooms {
    my ( $self ) = ( @_ );
    return scalar @{ $self->route };
} ## --- end sub remainedRooms

sub getRouteNextRoom{
    my ( $self ) = ( @_ );
    return $self->route->getRouteNextRoom;
}

sub extractRouteCurrentPart {
    my	( $self ) = @_;
    return $self->route->extractRouteCurrentPart;
} ## --- end sub extractRouteNextPart

package Room;
use base Building;

sub floor {
    $_[0]->{floor} = $_[1] if defined $_[1];return $_[0]->{floor};
} ## --- end sub floor

sub roomNumber {
    $_[0]->{roomNumber} = $_[1] if defined $_[1];return $_[0]->{roomNumber};
} ## --- end sub roomNumber

package Elevator;
use base Building;


package Route;

sub new {
    my $class = shift;
    my $self = [];

    bless $self,$class;
    return $self;
} ## --- end sub new

sub setRouteNextPart {
    my	( $self,$room,$timeInRoom )	= @_;
    my $routePart = RoutePart->new(
        room => $room,
        timeInRoom => $timeInRoom
    );
    push @$self,$routePart;
    return $self;
} ## --- end sub addRouteNextPart

sub extractRouteCurrentPart {
    my	( $self )	= @_;
    return shift @{$self};
} ## --- end sub getRouteNextPart

sub getRouteNextRoom {
    my	( $self )	= @_;
    return $self->[0]->room;
} ## --- end sub getRouteNextPart


package RoutePart;

sub new {
    my $class = shift;
    my $self = {@_};

    bless $self,$class;
    return $self;
} ## --- end sub new

sub room {
    $_[0]->{room} = $_[1] if defined $_[1];return $_[0]->{room};
} ## --- end sub room

sub timeInRoom {
    $_[0]->{timeInRoom} = $_[1] if defined $_[1];return $_[0]->{timeInRoom};
} ## --- end sub timeInRoom




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
	    push @list,[split /\s+/,$_];
	}
close $input;

my @agents = ();
my @rooms = ();
my %roomsCash = ();
my $elevator = Elevator->new( busy => 0,queue => [] );

foreach my $agentData ( @list ) {

    my $agentCode = shift @$agentData;
    my $entryTime = shift @$agentData;
    #my @roomsAndTime = split/\s+/,$agentData;
    #my $route = [];
    my $route = Route->new();

    for ( my $i = 0; $i < $#{$agentData}; $i+= 2 ) {
        my $room = undef;
        unless ( exists $roomsCash{ $agentData->[$i] }){
            my @roomData = split //,$agentData->[$i];

            $room = Room->new(  floor => join ('',$roomData[0],$roomData[1]),
                                roomNumber => join ('',$roomData[2],$roomData[3]),
                                busy => 0,
                                queue => []
            );
            $roomsCash{ $agentData->[$i] } = $room;
        }else{
            $room = $roomsCash{ $agentData->[$i] };
        }
            my $timeInRoom = $agentData->[$i+1];
            $route->setRouteNextPart($room,$timeInRoom);
            push @rooms,$room;
    }
    my $agent = Agent->new();
    $agent->rating( $agentCode );
    $agent->entryTime( $entryTime );
    $agent->status( Constants->justEnter );
    $agent->route( $route );
    $agent->currentFloor(1);
    push @agents,$agent;
}

@agents = sort { $a->entryTime <=> $b->entryTime }@agents;
my $time = $agents[0]->entryTime;
my $passedTime = 0;

foreach my $agent ( @agents ) {
    $agent->waitingTime( $agent->entryTime - $time );
}

my @finishedAgents = ();
my $timeCount = 0;
my %agentEvent = (
    Constants->justEnter => \&justEnter,
    Constants->toElevator => \&toElevator,
    Constants->toRoom => \&toRoom,
    Constants->inElevator => \&inElevator,
    Constants->inRoom => \&inRoom
);

#$DB::single = 2;
while( @agents > 0 ){
    if ( $timeCount ){
        timeProcess( \@agents );
        $time += 5;
        $passedTime += 5;
        $timeCount = 0;
        $elevator->busy(0);
    }else{
        mainProcess( \@agents,$time,$passedTime );
        $timeCount = 1;
    }
}
showResult( \@finishedAgents );


sub mainProcess{
    my $agents = shift;
    my $time = shift;
    my $passedTime = shift;
    
#    print "Start iteration ########################################################\n";
    foreach my $agent ( @$agents ) {
        #If agent approached
        if ( $agent->waitingTime == 0 ){
            $agentEvent{ $agent->status }->( $agent ) if exists ( $agentEvent{ $agent->status } );
        }
    }

    #Sort agents in elevator queue by rank
    $elevator->sortQueue;

    #Put agents into elevator one by one
    if ( $elevator->getQueueCount > 0 && !$elevator->busy ){
        my $agent = $elevator->getAgentFromQueue;
        $agent->status( Constants->inElevator );
        $agent->waitingTime($agent->waitingTime + 10);
        #       print "agent with rating ", $agent->rating," and status: ",$agent->status," going to be in the elevator ",$agent->waitingTime, " sec\n";
        $elevator->busy(1);
    }

    foreach my $room ( @rooms ) {
        #Sorting agents by rank in room queue
        $room->sortQueue;
        #Put agents into room one by one according by rank
        if ( $room->getQueueCount > 0 && !$room->busy ){
            my $agent = $room->getAgentFromQueue;
            $agent->status( Constants->inRoom );
            my $routePart = $agent->extractRouteCurrentPart;
            $agent->waitingTime( $agent->waitingTime + $routePart->timeInRoom );
#            print "agent with rating ", $agent->rating," going to be in the room ",$agent->waitingTime, " sec\n";
            $agent->currentRoom( $routePart->room );
            $agent->currentFloor( $room->floor );
            $room->busy(1);
        }
    }

#    if ( $time == 32900 ){
#        foreach my $agent ( @agents ) {
#            print $agent->status,"\n";
#            print $agent->waitingTime,"\n";
#        }
#        last;
#    }
#    print "agents waiting time!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
#    foreach my $agent ( @agents ) {
#        print "rating: ",$agent->rating," waiting time: ", $agent->waitingTime,"\n";
#    }
#    print "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";



    # $elevator->busy(0);
    for ( my $i = 0; $i <= $#{$agents}; $i++) {
        my $agent = $agents->[$i];
        if ( $agent->status == Constants->toExit && $agent->waitingTime == 0 ){
            $agent->exitTime( $time );
            $agents->[$i]->passedTime( $passedTime );
            push @finishedAgents,$agents->[$i];
            splice( @$agents,$i,1 );
        }
    }
#    print "End iteration ########################################################\n";

}

sub justEnter {
    my	( $agent )	= @_;
    #get room for agent visit
    my $room = $agent->getRouteNextRoom;
    #if room and agent are not at the same floor - we direct agent to elevator;
    if ( $room->floor != $agent->currentFloor ){
        $agent->status( Constants->toElevator );
        $agent->waitingTime( $agent->waitingTime + 10 );
#        print "agent with rating ", $agent->rating, " just enter and will be near elevator in ",$agent->waitingTime, " sec\n";
    #if room and agent are at the same floor - he need to approach the room
    }else{
        $agent->status( Constants->toRoom );
        $agent->waitingTime( $agent->waitingTime + 10 );
#        print "agent with rating ", $agent->rating," just enter and will be near room in ", $agent->waitingTime, " sec\n";
    }
} ## --- end sub justEnter

sub toElevator {
    my	( $agent )	= @_;
    #we put agent to elevator queue
    $agent->status( Constants->inQueueToElevator );
    $elevator->setAgentToQueue($agent);
} ## --- end sub toElevator

sub toRoom {
    my	( $agent )	= @_;
    #we put agent to room queue
    my $room = $agent->getRouteNextRoom;
    $agent->status( Constants->inQueueToRoom );
    $room->setAgentToQueue( $agent );
} ## --- end sub toRoom

sub inElevator {
    my	( $agent )	= @_;
    if ( $agent->remainedRooms == 0 ){
        $agent->status( Constants->toExit );
        #Agent heading from elevator to exit
        $agent->waitingTime($agent->waitingTime + 10);
#        print "agent with rating ", $agent->rating," from elevator directed to exit in a ",$agent->waitingTime, " sec\n";
    }else{
        $agent->status( Constants->toRoom );
        $agent->waitingTime($agent->waitingTime + 10);
#        print "agent with rating ", $agent->rating," and status: ",$agent->status," from elevator goes to room in a ",$agent->waitingTime, " sec\n";
    }
#    print "agent with rating ", $agent->rating," free elevator\n";
    $elevator->busy(0);
} ## --- end sub inElevator

sub inRoom {
    my	( $agent )	= @_;
    #If this room was last
    if ( $agent->remainedRooms == 0 ){
        $agent->status( Constants->toElevator );
        $agent->waitingTime($agent->waitingTime + 10);
#        print "agent with rating ", $agent->rating," goes to elevator and to exit in a ",$agent->waitingTime, " sec\n";
    }else{
        #get next room for agent visit
        my $nextRoom = $agent->getRouteNextRoom;
        #if room and agent are not at the same floor - we direct agent to elevator;
        if ( $nextRoom->floor != $agent->currentFloor ){
            $agent->status( Constants->toElevator );
            $agent->waitingTime( $agent->waitingTime + 10 );
#            print "agent with rating ", $agent->rating," goes to elevator (will be in a ",$agent->waitingTime, " sec) and to another floor\n";
        }else{
            $agent->status( Constants->toRoom );
            $agent->waitingTime( $agent->waitingTime + 10 );
#            print "agent with rating ", $agent->rating," goes from room to another room in a ",$agent->waitingTime, " sec\n";
        }
    }
    my $currentRoom = $agent->currentRoom;
    $currentRoom->busy(0);
} ## --- end sub inRoom

sub timeProcess{
    my $agents = shift;
#    print "-5 seconds\n";

    foreach my $agent ( @$agents ) {
        $agent->waitingTime( $agent->waitingTime - 5 );
    }
}

sub showResult{
    my $finishedAgentsRef = shift;
    my @finishedAgents = @$finishedAgentsRef;
    @finishedAgents = sort{ $a->entryTime <=> $b->entryTime }@finishedAgents;
    foreach my $agent ( @finishedAgents ) {
        print Constants->convertTime( $agent->entryTime )," ",Constants->convertTime( $agent->exitTime )," ",Constants->convertTime( $agent->passedTime ),"\n";
    }
}

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
