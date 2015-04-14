#!/usr/bin/perl -w

use Data::Dumper;
package Skyscraper;

sub new {
    my	$class = shift;
    my $self = {@_};
    bless $self,$class;
    return $self;
} ## --- end sub new

sub Roof{
    my	( $self,$x1,$y1,$x2,$y2 )	= @_;

    if ( defined $x1 && defined $y1 && defined $x2 && defined $y2 ){

    my $roof = Wall->new( $x1,$y1,$x2,$y2 );
       $self->{Roof} = $roof;
    }
    return $self->{Roof};
} ## --- end sub Roof

sub LeftSide{
    my	( $self,$x1,$y1,$x2,$y2 )	= @_;

    if ( defined $x1 && defined $y1 && defined $x2 && defined $y2 ){

    my $leftSide = Wall->new( $x1,$y1,$x2,$y2 );

        $self->{LeftSide} = $leftSide;
    }
    return $self->{LeftSide};
} ## --- end sub LeftSide

sub RightSide{
    my	( $self,$x1,$y1,$x2,$y2 )	= @_;

    if ( defined $x1 && defined $y1 && defined $x2 && defined $y2 ){

    my $rightSide = Wall->new( $x1,$y1,$x2,$y2 );

        $self->{RightSide} = $rightSide;
    }
    return $self->{RightSide};
} ## --- end sub RightSide


package Wall;

sub new {
    my	( $class,$x1,$y1,$x2,$y2 )	= @_;

    my $self = {};
    if ( defined $x1 && defined $y1 && defined $x2 && defined $y2 ){

        my $startP = Point->new(X => $x1,Y => $y1);
        my $stopP = Point->new(X => $x2,Y => $y2);
        $self->{StartPoint} = $startP;
        $self->{StopPoint} = $stopP;
    }
    bless $self,$class;
    return $self;
} ## --- end sub new


sub StartPoint {
    my	( $self,$x,$y )	= @_;

    if ( defined $x && defined $y ){

        my $startP = Point->new(X => $x,Y => $y);
        $self->{StartPoint} = $startP;
    }
    return $self->{StartPoint};
} ## --- end sub startPoint

sub StopPoint {
    my	( $self,$x,$y )	= @_;

    if ( defined $x && defined $y ){

        my $stopP = Point->new(X => $x,Y => $y);
        $self->{StopPoint} = $stopP;
    }
    return $self->{StopPoint};
} ## --- end sub stopPoint


package Point;

sub new {
    my	$class = shift;
    my $self = {@_};
    bless $self,$class;
    return $self;
} ## --- end sub new

sub X {
    $_[0]->{X} = $_[1] if defined $_[1];$_[0]->{X};
} ## --- end sub X

sub Y {
    $_[0]->{Y} = $_[1] if defined $_[1];$_[0]->{Y};
} ## --- end sub Y


#!/usr/bin/perl -d
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
	    push @list,[split /\s*;\s*/,$_];
	}
close $input;

#print Dumper \@list;


foreach my $arr ( @list ) {

    calc( $arr );
}

sub calc {
    my	( $arr )	= @_;

    my @skyscrappers = ();
    foreach my $c ( @$arr ) {

        my ($x1,$y2,$x4 ) = $c =~ /\((\d+)\,(\d+)\,(\d+)\)/;
        my $y1 = 0;
        my $x2 = $x1;
        my $x3 = $x4;
        my $y3 = $y2;
        my $y4 = 0;
#$DB::single = 2;

        my $skyscr = Skyscraper->new();
        $skyscr->LeftSide($x1,$y1,$x2,$y2);
        $skyscr->RightSide($x3,$y3,$x4,$y4);
        $skyscr->Roof($x2,$y2,$x3,$y3);

        push @skyscrappers,$skyscr;
#        print Dumper \$skyscr;
    }
#$DB::single = 2;
    my $way = [];
   $way->[0] = 0;
    for ( my $i=0; $i < $#skyscrappers; $i++ ) {

        #count ocverlapping skyscrappers
        my $count = 0;

        for ( my $j=$i+1;$j <= $#skyscrappers; $j++ ) {

            #print "i--->$i\n";
            #print "j--->$j\n";
            my $areCrossed = areOverlap( $skyscrappers[$i],$skyscrappers[$j],$way );
            if ( !$areCrossed && $count == 0 ){

                push @$way,$skyscrappers[$i]->RightSide->StartPoint->X;
                push @$way,$skyscrappers[$i]->RightSide->StopPoint->Y;
                last;

            }elsif ( !$areCrossed && $count > 0 ){

                last;
            }else{

                $count++;
            }
        }
    }
    #push @$way,$skyscrappers[-1]->RightSide->StartPoint->X;
    #push @$way,$skyscrappers[-1]->RightSide->StopPoint->Y;


    print Dumper \$way;
} ## --- end sub calc

sub getCrossingCoordinats {
    my	( $wall1,$wall2 )	= @_;

    my $state = -2;
    my $x = 0;
    my $y = 0;
#$DB::single = 2;
    #Если знаменатель n равен нулю то прямые параллельны
    #Если и числитель( m или w) и знаменатель (n) равны 0 то прямые совпадают
    #Если нужно найти пересечение отрезков, нужно проверить лежат ли ua и ub на промежутке [0:1]
    #Если какая нибудь из этих двух переменных 0 <= ui <= 1 то соответсвующий отрезок содержит точку пересечения
    #если обе переменные приняли значения из промежутка [0:1] то точка пересечения лежит внутри обоих отрезков

    my $m = ( ($wall2->StopPoint->X - $wall2->StartPoint->X) * ($wall1->StartPoint->Y - $wall2->StartPoint->Y) -
              ($wall2->StopPoint->Y - $wall2->StartPoint->Y) * ($wall1->StartPoint->X - $wall2->StartPoint->X) );

    my $w = ( ($wall1->StopPoint->X - $wall1->StartPoint->X) * ($wall1->StartPoint->Y - $wall2->StartPoint->Y) -
              ($wall1->StopPoint->Y - $wall1->StartPoint->Y) * ($wall1->StartPoint->X - $wall2->StartPoint->X) );

    my $n = ( ($wall2->StopPoint->Y - $wall2->StartPoint->Y) * ($wall1->StopPoint->X - $wall1->StartPoint->X) -
              ($wall2->StopPoint->X - $wall2->StartPoint->X) * ($wall1->StopPoint->Y - $wall1->StartPoint->Y) );

    my $ua = $m / $n;
    my $ub = $w / $n;

    if ( $n == 0 && $m != 0 ){

        #Прямые параллельны и непересек
        $state = -1;

    }elsif( $n == 0 && $m == 0 ){

        #Прямые совпадают
        $state = 0;

    }else{

        #Прямые имеют точку пересечения
        $x = $wall1->StartPoint->X + $ua * ( $wall1->StopPoint->X - $wall1->StartPoint->X );
        $y = $wall1->StartPoint->Y + $ua * ( $wall1->StopPoint->Y - $wall1->StartPoint->Y );

        #проверка попадания в интервал
        my $a = ( $x >= $wall1->StartPoint->X ) ? 1 : 0;
        my $b = ( $x <= $wall1->StartPoint->X ) ? 1 : 0;
        my $c = ( $x >= $wall2->StartPoint->X ) ? 1 : 0;
        my $d = ( $x <= $wall2->StartPoint->X ) ? 1 : 0;

        my $e = ( $y >= $wall1->StartPoint->Y ) ? 1 : 0;
        my $f = ( $y <= $wall1->StartPoint->Y ) ? 1 : 0;
        my $g = ( $y >= $wall2->StartPoint->Y ) ? 1 : 0;
        my $h = ( $y <= $wall2->StartPoint->Y ) ? 1 : 0;

        if ( (($a || $b) && ($c || $d)) && (($e||$f) && ($g||$h)) ){

            $state = 1;
        }
    }

    return [$x,$y];
} ## --- end sub getCrossingCoordinats

sub areOverlap {
    my	( $skyscr1,$skyscr2,$way )	= @_;

    if ( $way->[-1] == 0 ){

        my $x = $skyscr1->LeftSide->StartPoint->X;
        my $y = $skyscr1->LeftSide->StopPoint->Y;

        push @$way,$x;
        push @$way,$y;

        print "********************\n";
        print "Added ",$skyscr1->LeftSide->StopPoint->X, " and ", $skyscr1->LeftSide->StopPoint->Y,"\n";
        print "********************\n";
        print Dumper \$way;
    }

    print "##################################################################################\n";
    print Dumper \$skyscr1;
    print Dumper \$skyscr2;
    #There is overlapp
    if ( $skyscr1->RightSide->StartPoint->X > $skyscr2->LeftSide->StartPoint->X ){

        # $DB::single = 2;
        #First skyscraper's roof higher than seconds
        if ( $skyscr1->Roof->StartPoint->Y > $skyscr2->Roof->StartPoint->Y ){

            #$DB::single = 2;
            my $coords = getCrossingCoordinats( $skyscr1->RightSide,$skyscr2->Roof );
            push @$way,$skyscr1->Roof->StopPoint->X;
            push @$way,$coords->[1];
            print "1********************\n";
            print "Added ",$skyscr1->Roof->StopPoint->X, " and $coords->[1]\n";

        #Second skyscraper's roof higher than first
        }else{
            my $coords = getCrossingCoordinats( $skyscr1->Roof,$skyscr2->LeftSide );
            push @$way,$coords->[0];
            push @$way,$skyscr2->Roof->StartPoint->Y;
            print "2*************************\n";
            print "Added ",$skyscr2->Roof->StartPoint->Y, " and $coords->[0]\n";

            #Check right side of second skyscraper
            if ( $skyscr1->RightSide->StartPoint->X > $skyscr2->RightSide->StartPoint->X ){

                #if right side of second skyscr also crossing roof of first skyscr
                push @$way,$skyscr2->Roof->StopPoint->X;
                my $coords = getCrossingCoordinats( $skyscr1->Roof,$skyscr2->RightSide );
                push @$way,$coords->[1];
                print "3****************************\n";
                print "Added ",$skyscr2->Roof->StopPoint->X , " and $coords->[1]\n";

            }
        }
        return 1;

    }else{

        return 0;
    }
print "##################################################################################\n";
} ## --- end sub areOverlap

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
