#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper; 
use Benchmark;
use URI;
my $t0 = new Benchmark;
open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
# open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";



my @list = (); 
	 
	while(<$input>){			
	chomp;	
	push @list,[split /\|/,$_];
	}
close $input;

#print Dumper \@list;
foreach(@list){
	
    my @result = ();
	 my @arr1 = $_->[0]=~ /-*\d+\,-*\d+/g;
	 my @arr2 = split /;/,$_->[1];
	 
	 foreach(@arr2){
	 	s/\s+\[/,/g;
	 	s/\]//g;
	 	s/\(//g;
	 	s/\)//g;
	}
	

    foreach ( @arr2 ) {

        my $res = calc(\@arr1,$_);
        push @result,$res unless ($res == -1);
    }
    if (scalar @result > 0){

        print join (",",sort{$a<=>$b}@result),"\n";
    
    }else{
    
        print "-\n";
    }
    #  print Dumper \@arr1;
    #  print Dumper \@arr2;
	 
}




sub calc {
    my	( $koord1,$koord2 )	= @_;

    my ($x1,$y1) = split /,/,$koord1->[0];
    my ($x2,$y2) = split /,/,$koord1->[1];
    my ($x3,$y3) = ($x1,$y2);
    my ($x4,$y4) = ($x2,$y1);

    my $oX = calc_side2D($x2,$y2,$x3,$y3);
    my $oY = calc_side2D($x4,$y4,$x2,$y2);

    
    #************************************
    
    my ($index,$dx1,$dy1,$dz1,$dx2,$dy2,$dz2) = split /,/,$koord2;
    
    my $odX = calc_side3D($dx2,$dy2,$dz1,$dx1,$dy2,$dz1);
    my $odY = calc_side3D($dx2,$dy2,$dz1,$dx2,$dy1,$dz1);
    my $odZ = calc_side3D($dx2,$dy2,$dz1,$dx2,$dy2,$dz2);
    
    

                  if ($oX  >= $odX && $oY >= $odY ||
                      $oX  >= $odY && $oY >= $odX ||
                      $oX  >= $odY && $oY >= $odZ || 
                      $oX  >= $odZ && $oY >= $odY ||
                      $oX  >= $odX && $oY >= $odZ ||
                      $oX  >= $odZ && $oY >= $odX     
                     ){
                     
                            return $index;
                     }else{
                            
                            return -1;                     
                     }
        
} ## --- end sub calc


sub calc_side2D {
    my	( $x1,$y1,$x2,$y2 )	= @_;

    my $side = sqrt( ($x2 - $x1)**2 + ($y2 - $y1)**2 );
    return $side;
} ## --- end sub calc_side


sub calc_side3D {
    my	( $x1,$y1,$z1,$x2,$y2,$z2 )	= @_;

    my $side = sqrt( ($x2 - $x1)**2 + ($y2 - $y1)**2 + ($z2 - $z1)**2 );
    return $side;
} ## --- end sub calc_side


my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
