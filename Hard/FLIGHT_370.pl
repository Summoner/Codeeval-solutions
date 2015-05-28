#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper;
#use DateTime::Format::Strptime;
use DateTime;

package Placemark;

sub new {
    my $class = shift;
    my $self = {@_};
    bless $self,$class;
    return $self;
} ## --- end sub new

sub id {
    $_[0]->{id} = $_[1] if defined $_[1];$_[0]->{id};
} ## --- end sub id

sub name {
    $_[0]->{name} = $_[1] if defined $_[1];$_[0]->{name};
} ## --- end sub name

sub type {
    $_[0]->{type} = $_[1] if defined $_[1];$_[0]->{type};
} ## --- end sub type

sub confirmationsCount {
    $_[0]->{confirmationsCount} = $_[1] if defined $_[1];$_[0]->{confirmationsCount};
} ## --- end sub confirmationsCount

sub timeStamp {
    my ( $self,$dateInString ) = @_;

    return $self->{timeStamp} unless defined ( $dateInString );

    #my $strPars = DateTime::Format::Strptime->new( pattern => '%F %T' );
    #my $dtObj = $strPars->parse_datetime( $dateInString );
    if ( $dateInString =~ m/(\d{4})\-(\d{2})\-(\d{2})\s+(\d{1,2})\:(\d{1,2})\:(\d{1,2})\.\d+/ ){

        my $dtObj = DateTime->new(
                    year => $1,
                    month => $2,
                    day => $3,
                    hour => $4,
                    minute => $5,
                    second => $6
        );
        $self->{timeStamp} = $dtObj;
    }
    return $self->{timeStamp};
} ## --- end sub timeStamp

sub point {
    $_[0]->{point} = $_[1] if defined $_[1];$_[0]->{point};
} ## --- end sub point

1;
package Point;

sub new {
    my $class = shift;
    my $self = {@_};
    bless $self,$class;
    return $self;
} ## --- end sub new

sub latitude {
    $_[0]->{latitude} = $_[1] if defined $_[1];$_[0]->{latitude};
} ## --- end sub latitude

sub longtitude {
    $_[0]->{longtitude} = $_[1] if defined $_[1];$_[0]->{longtitude};
} ## --- end sub longtitude

1;
use Data::Dumper;
use Math::Trig;
use Benchmark;

my $t0 = new Benchmark;

 open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.kmz" || die "Can't open file: $!\n";
 #open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";

my @placemarks = ();
my @startData = ();

my $idPlacemark = undef;
my $namePlacemark = undef;
my $typePlacemark = undef;
my $confirmationsPlacemark = undef;
my $timeStampPlacemark = undef;
my $latitudePlacemark = undef;
my $longtitudePlacemark = undef;

my $foldersInProcess = 0;
my $placemarksInProcess = 0;
my $regionsInProcess = 1;

    while(<$input>){
    	chomp;

        if ( m/\<\?xml\s+version\=\'1\.0\'\s+encoding\=\'UTF\-8\'\?\>/ ){

            $regionsInProcess = 0;
            $placemarksInProcess = 1;

        }elsif ( m/\<Folder\sid='overlays'\>/){

            $placemarksInProcess = 0;
            $foldersInProcess = 1;
        }

        if ( $placemarksInProcess ){

            #Placemarks parse here
            if ( m/\<\/Placemark\>/){
                #$DB::single = 2;
                my $point = Point->new("longtitude" => $longtitudePlacemark,"latitude" => $latitudePlacemark );
                my $placemark = Placemark->new();
                    $placemark->id($idPlacemark);
                    $placemark->name($namePlacemark);
                    $placemark->type($typePlacemark);
                    $placemark->confirmationsCount($confirmationsPlacemark);
                    $placemark->timeStamp($timeStampPlacemark);
                    $placemark->point($point);

                    push @placemarks,$placemark;

            }
            if ( $_ =~ m/\<Placemark\s+id='(\d+)'\>/ ){

                $idPlacemark = $1;

            }elsif ( $_ =~ m/\<name\>([a-zA-Z0-9\s+_]+)\<\/name\>/ ){

                $namePlacemark = $1;

            }elsif ( $_ =~ m/\<type\>(\w+)\<\/type\>/ ){

                $typePlacemark = $1;

            }elsif ( $_ =~ m/Confirmation:\s+\<b\>(\d+)\<\/b\>\s+people\<br\/\>/ ){

                $confirmationsPlacemark = $1;

            }elsif ( $_ =~ m/\<TimeStamp\>\<when\>(\d{4}\-\d{2}\-\d{2}\s+\d{2}\:\d{2}\:\d{2}\.\d+)\<\/when\>\<\/TimeStamp\>/ ){

                $timeStampPlacemark = $1;

            }elsif ( $_ =~ m/\<Point\>\<coordinates\>(\-*\d+\.\d+)\,(\-*\d+\.\d+)\<\/coordinates\>\<\/Point\>/ ){

                ( $longtitudePlacemark,$latitudePlacemark ) = ($1,$2);
            }

        }elsif( $regionsInProcess ){

            #Regions parse here
		    if( $_ =~ m/(\d+)\;\s+\((\-*\d+\.\d+)\,\s+(\-*\d+\.\d+)\)/ ){

                push @startData,[$1,$2,$3];
            }
        }
	}
close $input;

foreach my $arr ( @startData ) {

    print calc( $arr,\@placemarks);
}


sub calc {
    my	( $startData,$placemakers )	= @_;
    #$DB::single = 2;
    my $radius = $startData->[0];
    my $startLongtitude = $startData->[1];
    my $startLatitude = $startData->[2];

    my @confirmedPlaces = ();

    foreach my $placemaker ( @$placemakers ) {

        if ( calcDistance( $startLongtitude,$startLatitude,$placemaker->point->longtitude,$placemaker->point->latitude ) < $radius ){

            push @confirmedPlaces,$placemaker;
        }
    }

    return "None\n" if ( scalar @confirmedPlaces == 0 );
    my $maxPeople = undef;
    my @confirmedMaxPeoplePlaces = sort{ $b->confirmationsCount <=> $a->confirmationsCount }@confirmedPlaces;

    my @resultPlaces = ();
    foreach my $placemaker ( @confirmedMaxPeoplePlaces ) {

        if ( !defined $maxPeople ){

            $maxPeople = $placemaker->confirmationsCount;
            #push @resultPlaces, $placemaker;
        }
        if ( defined $maxPeople && $maxPeople != $placemaker->confirmationsCount ){

            last;
        }
        push @resultPlaces, $placemaker;
    }

    my @sorted = map{$_->name} sort{ DateTime->compare( $b->timeStamp, $a->timeStamp ) ||
                                    $a->id <=> $b->id }@resultPlaces;
    return join (", ",@sorted),"\n";
} ## --- end sub calc

sub calcDistance {
    my	( $longtitudeD1,$latitudeD1,$longtitudeD2,$latitudeD2 )	= @_;
    my $R = 6371000;
    my $longtitudeR1 = deg2rad($longtitudeD1);
    my $longtitudeR2 = deg2rad($longtitudeD2);

    my $latitudeR1 = deg2rad($latitudeD1);
    my $latitudeR2 = deg2rad($latitudeD2);

    my $Dphi = deg2rad($latitudeD2 - $latitudeD1);
    my $Dlambda = deg2rad($longtitudeD2 - $longtitudeD1);

    my $a = sin( $Dphi/2 ) * sin( $Dphi/2 ) + cos( $latitudeR1 ) * cos( $latitudeR2 ) * sin( $Dlambda/2 ) * sin( $Dlambda/2 );
    my $c = 2 * atan2( sqrt($a),sqrt(1-$a) );
    my $d = $R * $c;
    return $d/1000;
} ## --- end sub calcDistance

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
