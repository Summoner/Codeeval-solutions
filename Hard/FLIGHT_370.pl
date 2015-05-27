#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper;
use DateTime::Format::Strptime;

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
    my $strPars = DateTime::Format::Strptime->new( pattern => '%F %T' );
    my $dtObj = $strPars->parse_datetime( $dateInString );
    $self->{timeStamp} = $dtObj;
    return $self->{timeStamp};
} ## --- end sub timeStamp

sub point {
    $_[0]->{point} = $_[1] if defined $_[1];$_[0]->{point};
} ## --- end sub point
1;

package Folder;

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

sub point1 {
    $_[0]->{point1} = $_[1] if defined $_[1];$_[0]->{point1};
} ## --- end sub point1

sub point2 {
    $_[0]->{point2} = $_[1] if defined $_[1];$_[0]->{point2};
} ## --- end sub point2

sub point3 {
    $_[0]->{point3} = $_[1] if defined $_[1];$_[0]->{point3};
} ## --- end sub point3

sub point4 {
    $_[0]->{point4} = $_[1] if defined $_[1];$_[0]->{point4};
} ## --- end sub point4

sub point5 {
    $_[0]->{point5} = $_[1] if defined $_[1];$_[0]->{point5};
} ## --- end sub point5

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
my @folders = ();
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

my $idFolder = undef;
my $nameFolder = undef;
my $longtitudeFolder1 = undef;
my $lattitudeFolder1 = undef;
my $longtitudeFolder2 = undef;
my $lattitudeFolder2 = undef;
my $longtitudeFolder3 = undef;
my $lattitudeFolder3 = undef;
my $longtitudeFolder4 = undef;
my $lattitudeFolder4 = undef;
my $longtitudeFolder5 = undef;
my $lattitudeFolder5 = undef;




	while(<$input>){
    	chomp;

        if ( m/\<\?xml\s+version\=\'1\.0\'\s+encoding\=\'UTF\-8\'\?\>/ ){

            $regionsInProcess = 0;
            $placemarksInProcess = 1;

        }elsif ( m/\<Folder\sid='overlays'\>/){

            $placemarksInProcess = 0;
            $foldersInProcess = 1;
        }

        if( $foldersInProcess ){

            #Folders parse here
            if ( m/\<\/Folder\>/){

                push @folders,[ $idFolder,$nameFolder,$longtitudeFolder1,$lattitudeFolder1,
                                                      $longtitudeFolder2,$lattitudeFolder2,
                                                      $longtitudeFolder3,$lattitudeFolder3,
                                                      $longtitudeFolder4,$lattitudeFolder4,
                                                      $longtitudeFolder5,$lattitudeFolder5 ];
            }
            if ( $_ =~ m/\<Folder\s+id='([a-zA-Z0-9_]+)'\>/ ){

                $idFolder = $1;

            }elsif ( $_ =~ m/\<name\>([a-zA-Z0-9\s+_]+)\<\/name\>/ ){

                $nameFolder = $1;

            }elsif( $_ =~ m/\<LinearRing\>\<coordinates\>(\-*\d+\.\d+)\,(\-*\d+\.\d+)\s+(\-*\d+\.\d+)\,(\-*\d+\.\d+)\s+(\-*\d+\.\d+)\,(\-*\d+\.\d+)\s+(\-*\d+\.\d+)\,(\-*\d+\.\d+)\s+(\-*\d+\.\d+)\,(\-*\d+\.\d+)\<\/coordinates\>\<\/LinearRing\>/ ){

                ( $longtitudeFolder1, $lattitudeFolder1,
                  $longtitudeFolder2, $lattitudeFolder2,
                  $longtitudeFolder3, $lattitudeFolder3,
                  $longtitudeFolder4, $lattitudeFolder4,
                  $longtitudeFolder5, $lattitudeFolder5 ) = ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10);
            }
        }elsif ( $placemarksInProcess ){

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

#print Dumper \@placemarks;
#print Dumper \@folders;
#print Dumper \@startData;

# calcDistance(96,4,92,11);

my @folderObjects = ();
foreach my $folderData ( @folders ) {

    my $point1 = Point->new("longtitude" => $folderData->[2],"latitude" => $folderData->[3] );
    my $point2 = Point->new("longtitude" => $folderData->[4],"latitude" => $folderData->[5] );
    my $point3 = Point->new("longtitude" => $folderData->[6],"latitude" => $folderData->[7] );
    my $point4 = Point->new("longtitude" => $folderData->[8],"latitude" => $folderData->[9] );
    my $point5 = Point->new("longtitude" => $folderData->[10],"latitude" => $folderData->[11] );

    my $folder = Folder->new( "id" => $folderData->[0],
                                    "name" => $folderData->[1],
                                    "point1" => $point1,
                                    "point2" => $point2,
                                    "point3" => $point3,
                                    "point4" => $point4,
                                    "point5" => $point5 );
    push @folderObjects,$folder;
}

#print Dumper \@placeObjects;
#print Dumper \@folderObjects;
#print Dumper \@startData;


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

    
    #print compareDates( $resultPlaces[0]->timeStamp,$resultPlaces[1]->timeStamp );
    #print Dumper \@resultPlaces;
    my @sorted = map{$_->name} sort{ DateTime->compare( $b->timeStamp, $a->timeStamp ) ||
                                    $a->id <=> $b->id }@resultPlaces;
    
    #print Dumper \@sorted;
    return join (", ",@sorted),"\n";
} ## --- end sub calc



sub compareDates {
    my	( $date1,$date2 )	= @_;

    my $result = DateTime->compare($date1,$date2);
    return $result;  
} ## --- end sub compareDates



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
