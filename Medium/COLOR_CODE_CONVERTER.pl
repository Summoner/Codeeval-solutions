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
	push @list,[split /,/,$_];
	}
close $input;

#print Dumper \@list;

foreach my $str (@list){

}


sub hsl_rgb {
    my	( $h,$s,$l )	= @_;
    my $r = 0;
    my $g = 0;
    my $b = 0;
    my $var_1 = 0;
    my $var_2 = 0;

    if ($s == 0){
    
        $r = $g = $b = $l * 255; #achromatic
    }else{
    
        if ($l < 0.5){
        
            $var_2 = $l * (1 + $s);
        }else{
        
            $var_2 = ( $l + $s ) - ($s * $l);
        }
        $var_1 = 2 * $l - $var_2;

        $r = 255 * Hue_2_RGB( $var_1, $var_2, $h + (1/3));
        $g = 255 * Hue_2_RGB( $var_1, $var_2, $h);
        $b = 255 * Hue_2_RGB( $var_1, $var_2, $h - (1/3));

    }

    return [ $r,$g,$b ] ;
} ## --- end sub hsl_rgb


sub Hue_2_RGB {
    my	( $v1,$v2,$vh )	= @_;

  $vh++  if ($vh < 0);
  $vh--  if ($vh > 1);

  return ( $v1 + ($v2 - $v1) * 6 * $vh) if ((6 * $vh) < 1);
  return ( $v2 ) if ((2 * $vh) < 1);
  return ( $v1 + ($v2 - $v1) * (2/3 - $vh) * 6) if ((3 * $vh) < 2);
  return $v1;
} ## --- end sub Hue_2_RGB
my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
