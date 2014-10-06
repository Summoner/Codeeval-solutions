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
	    push @list,[split /\)\s+\(/,$_];
	}
close $input;



foreach my $arr_ref ( @list ) {

    foreach my $str (@$arr_ref ) {

         $str =~ s/\(//;
         $str =~ s/\)//;
    }

my @Xc = split /,/, $arr_ref->[0];
my @Yc = split /,/, $arr_ref->[1];

my $blocks = calc(\@Xc,\@Yc);
print $blocks,"\n";

}


#print Dumper \@Xc;
#print Dumper \@Yc;



sub calc{
my ($Xc,$Yc) = @_;

my $slope = $Yc->[-1]/$Xc->[-1];
my $blocks = 0;

for ( my $i=0; $i < scalar @$Yc -1; $i++ ) {

    for ( my $j=0; $j < scalar @$Xc -1; $j++ ) {

    
        my $x1 = $Xc->[$j];
        my $x2 = $Xc->[$j+1];

        my $y1 = $Yc->[$i];
        my $y2 = $Yc->[$i+1];

        if ((($slope * $x1) < $y2) && (($slope * $x2) > $y1)){
        
            $blocks++;
        
        }
     }
}

return $blocks;
}





my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
