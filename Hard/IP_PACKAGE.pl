#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper;
use Benchmark;
use integer;

my $t0 = new Benchmark;

  open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
 #open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";

my  @packages = ();

	while(<$input>){
    	chomp;
	    push @packages,[split /\s+/,$_];
	}
close $input;


#print Dumper \@packages;












foreach my $package ( @packages ) {

    my $newSourceIP = shift @$package;
    my $newDestIP = shift @$package;

#    my $test = $package->[0];
#    print "first: $test\n";
#    my $binRes = hexToBin( $test );
#    print "bin result: $binRes\n";
#    my $hexRes = binToHex( $binRes );
#    print "hex result: $hexRes\n";
 
    analyzePackage( $package );  
   
    my $add1 = hex $package->[3];
    my $add2 = hex $package->[4];

    #my $add1 = 0xdc;
    #my $add2 = 0xb7;
    #my $temp = hex $package->[3] + hex $package->[4];
    #my $temp = 0;
    #$temp = $temp + $add2;
    #print $add1,"\n";
    #print $add2,"\n";

    #print hex $package->[3],"\n";
    #print hex $package->[4],"\n";
    #printf "%x",$temp,"\n";



}

#my $hex1 = 0x865E;
#my $hex2 = 0xac60;
#print "*****************************\n";
#my $res = $hex1 + $hex2;
#printf "%x",$res,"\n";


sub analyzePackage {
    my	( $package )	= @_;


    for ( my $i=0;$i <= $#{$package}; $i++ ) {

       print "$i --> $package->[$i]\n";
    }
    my $controlSumm = hex join "",($package->[10],$package->[11]);
    my $checkSumm = 0;

    for ( my $i = 0;$i <= $#{$package}; $i++ ) {

        next if ( $i == 10 || $i == 11 );
        print "**************************************************************\n";
        print "checkSumm before adding package part $package->[$i]\n";
        printf "%x",$checkSumm,"\n";
        print "\n";
        $checkSumm = $checkSumm + hex $package->[$i];
        print "checkSumm after added package part $package->[$i]\n";
        printf "%x",$checkSumm,"\n";
        print "\n";
    }
printf "%x",$controlSumm,"\n";
print "\n";
print "***************************\n";
printf "%x",$checkSumm,"\n";
print "\n";

    return ;
} ## --- end sub analyzePackage



sub hexToBin {
    my	( $hexData )	= @_;

    my $res = unpack( 'B*',pack('H*',$hexData ));
    return $res;
} ## --- end sub hexToBin

sub binToHex {
    my	( $binData )	= @_;

    my $res = unpack( 'H*',pack('B*',$binData ));
    return $res;
} ## --- end sub binToHex


my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
