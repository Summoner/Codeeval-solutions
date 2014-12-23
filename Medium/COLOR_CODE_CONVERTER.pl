#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper;
use Benchmark;

my $t0 = new Benchmark;
open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
# open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";

my @list = ();

	while(<$input>){
        chomp;
	    push @list,[split //,$_];
	}
close $input;

#print Dumper \@list;

foreach my $str (@list){

    if ( $str->[0] eq "#" ){

        hex_to_rgb( $str );

    }elsif( $str->[0] eq "H" && $str->[1] eq "S" && $str->[2] eq "L" ){

        hsl_to_rgb( $str );

    }elsif( $str->[0] eq "H" && $str->[1] eq "S" && $str->[2] eq "V" ){

        hsv_to_rgb( $str );
    }else{

        cmyk_to_rgb( $str );
    }
}

sub cmyk_to_rgb {
    my	( $arr )	= @_;

    my $str = join "",@$arr;
    my ( $C,$M,$Y,$K ) = $str =~ /\((\d+\.\d+)\,(\d+\.\d+)\,(\d+\.\d+)\,(\d+\.\d+)\)/;

    my $R = 255 * (1-$C) * (1-$K);
    my $G = 255 * (1-$M) * (1-$K);
    my $B = 255 * (1-$Y) * (1-$K);

    print "RGB(",join (",",round($R),round($G),round($B)), ")","\n";
} ## --- end sub cmyk_to_rgb

sub hsv_to_rgb {
    my	( $arr )	= @_;
    my $str = join "",@$arr;

	my ( $H,$S,$V ) = $str =~ /HSV\((\d+)\,(\d+)\,(\d+)\)/;
#$DB::single = 2;
    $S = $S/100;
    $V = $V/100;
    my $C = $V * $S;
    my $X = $C * (1 - abs( remainder($H) -1));
    my $m = $V - $C;

    my ( $R1,$G1,$B1 ) = 0;

    ( $R1,$G1,$B1 ) = ( $C,$X,0 ) if ( $H >= 0 && $H < 60 );
    ( $R1,$G1,$B1 ) = ( $X,$C,0 ) if ( $H >= 60 && $H < 120 );
    ( $R1,$G1,$B1 ) = ( 0,$C,$X ) if ( $H >= 120 && $H < 180 );
    ( $R1,$G1,$B1 ) = ( 0,$X,$C ) if ( $H >= 180 && $H < 240 );
    ( $R1,$G1,$B1 ) = ( $X,0,$C ) if ( $H >= 240 && $H < 300 );
    ( $R1,$G1,$B1 ) = ( $C,0,$X ) if ( $H >= 300 && $H < 360 );

    my ( $R,$G,$B ) = ( ($R1 + $m)*255,($G1+ $m)*255,($B1 + $m)*255 );

    print "RGB(",join (",",round($R),round($G),round($B)), ")","\n";
} ## --- end sub hsv_to_rgb

sub hsl_to_rgb {
    my	( $arr )	= @_;
    my $str = join "",@$arr;

	my ( $H,$S,$L ) = $str =~ /HSL\((\d+)\,(\d+)\,(\d+)\)/;
    $S = $S/100;
    $L = $L/100;
    my $C = (1 - abs ( 2 * $L - 1 )) * $S;
    my $X = $C * (1 - abs( remainder($H) -1));
    my $m = $L - $C/2;

    my ( $R1,$G1,$B1 ) = 0;

    ( $R1,$G1,$B1 ) = ( $C,$X,0 ) if ( $H >= 0 && $H < 60 );
    ( $R1,$G1,$B1 ) = ( $X,$C,0 ) if ( $H >= 60 && $H < 120 );
    ( $R1,$G1,$B1 ) = ( 0,$C,$X ) if ( $H >= 120 && $H < 180 );
    ( $R1,$G1,$B1 ) = ( 0,$X,$C ) if ( $H >= 180 && $H < 240 );
    ( $R1,$G1,$B1 ) = ( $X,0,$C ) if ( $H >= 240 && $H < 300 );
    ( $R1,$G1,$B1 ) = ( $C,0,$X ) if ( $H >= 300 && $H < 360 );

    my ( $R,$G,$B ) = ( ($R1 + $m)*255,($G1+ $m)*255,($B1 + $m)*255 );

    print "RGB(",join (",",round($R),round($G),round($B)), ")","\n";


} ## --- end sub hsl_to_rgb


sub hex_to_rgb {
    my	( $arr )	= @_;
    shift @$arr;

    my $R = join ("", $arr->[0],$arr->[1]);
    my $G = join ("", $arr->[2],$arr->[3]);
    my $B = join ("", $arr->[4],$arr->[5]);

    $R = sprintf( "%d",hex($R));
    $G = sprintf( "%d",hex($G));
    $B = sprintf( "%d",hex($B));

    print "RGB(",join (",",round($R),round($G),round($B)), ")","\n";

} ## --- end sub hex_to_rgb

sub remainder {
    my	( $H )	= @_;

    my $part1 = (int ( $H/60 )) % 2;
    my $part2 = $H/60 - int ( $H/60 );
    return $part1 + $part2 ;
} ## --- end sub remainder

sub round {
    my	( $inp )	= @_;

    return int ($inp + 0.5) ;
} ## --- end sub round

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
