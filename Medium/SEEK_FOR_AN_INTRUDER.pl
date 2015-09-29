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
	    push @list,$_;
	}
close $input;

#print Dumper \@list;

my $ipAdresses = {};
foreach my $str (@list){

    #Binary
    my @ipAdressesBinary = ($str =~ m/([0|1]{31,32})/g);
    push @{ $ipAdresses->{binary} },@ipAdressesBinary;
    #Dotted binary
    my @ipAdressesDottedBinary = ($str =~ m/([0|1]{8}\.[0|1]{8}\.[0|1]{8}\.[0|1]{8})/g);
    push @{ $ipAdresses->{dottedBinary} },@ipAdressesDottedBinary;
    #Octal
	my @ipAdressesOctal = ($str =~ m/\D{0,}([0-9]{12})\D{0,}/g);
    push @{ $ipAdresses->{octal} }, @ipAdressesOctal;
    #Decimal
    my @ipAdressesDecimal = ($str =~ m/\D{0,}([0-9]{10})\D{0,}/g);
    push @{ $ipAdresses->{decimal} },@ipAdressesDecimal;
    #Dotted decimal
    my @ipAdressesDottedDecimal = ($str =~ m/([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})/g);
    push @{ $ipAdresses->{dottedDecimal} },@ipAdressesDottedDecimal;
    #Dotted octal
    my @ipAdressesDottedOctal = ($str =~ m/(0{1}[0-9]{3}\.0{1}[0-9]{3}\.0{1}[0-9]{3}\.0{1}[0-9]{3})/g);
    push @{ $ipAdresses->{dottedOctal} },@ipAdressesDottedOctal;
    #Dotted hexadecimal
	my @ipAdressesDottedHexadecimal = ($str =~ m/(0{1}x{1}[0-9A-F]{1,3}\.0{1}x{1}[0-9A-F]{1,3}\.0{1}x{1}[0-9A-F]{1,3}\.0{1}x{1}[0-9A-F]{1,3})/gi);
    push @{ $ipAdresses->{dottedHexadecimal} },@ipAdressesDottedHexadecimal;
    #Hexadecimal
	my @ipAdressesHexadecimal = ($str =~ m/(0{1}x{1}[0-9A-Fa-f]{8})/g);
    push @{ $ipAdresses->{hexadecimal} },@ipAdressesHexadecimal;
}

#print Dumper \$ipAdresses;

#print DecimalIpToDecimal($ipAdresses->{decimal}->[0] ),"\n";

my $IPsList = GetIPs( $ipAdresses );

my $validIps = RemoveInvalidIPs( $IPsList );

#print Dumper \$validIps;

my $ip = GetMoreOftenIP( $validIps );

print "$ip\n";
sub GetMoreOftenIP {
    my	( $IPs )	= @_;

    my $maxOftenOccurs = 0;
  
    foreach my $ip ( keys %{ $IPs } ) {
        if ( $IPs->{$ip} > $maxOftenOccurs ){
            $maxOftenOccurs = $IPs->{$ip};
        }
    }
    my @resultIPs = grep{ $IPs->{$_} == $maxOftenOccurs }keys %{ $IPs };
    @resultIPs = sort { $a cmp $b } @resultIPs;
    return join " ",@resultIPs;
} ## --- end sub GetMoreOftenIP

sub RemoveInvalidIPs {
    my	( $ipAdresses )	= @_;

    my $validIPs = {};
    foreach my $ip ( keys $ipAdresses ) {
        my @digits = split /\./,$ip;
        if ( scalar @digits == 4 ){

            if ( $digits[0] <= 255 && $digits[1] <= 255 && $digits[2] <= 255 && $digits[3] < 255 ){
                $validIPs->{$ip} = $ipAdresses->{$ip};
            }
            
        }
    }
    return $validIPs;
} ## --- end sub RemoveInvalidIPs

sub GetIPs {
    my	( $ipAdresses )	= @_;

    my @ipAddr = @{ $ipAdresses->{binary} };
    my %IP = ();

    if ( scalar @ipAddr > 0 ){
        foreach my $ip ( @ipAddr ) {

            my @digits = split //,$ip;
            my $res = BinaryIpToDecimal( \@digits );
            $IP{$res}++;
        }
    }
#$DB::single = 2;
    @ipAddr = @{ $ipAdresses->{dottedBinary} };
    if ( scalar @ipAddr > 0 ){
        foreach my $ip ( @ipAddr ) {

            my $res = DottedBinaryIpToDecimal( $ip );
            $IP{$res}++;
        }
    }

    @ipAddr = @{ $ipAdresses->{octal} };
    if ( scalar @ipAddr > 0 ){
        foreach my $ip ( @ipAddr ) {

            my $res = OctalIpToDecimal( $ip );
            $IP{$res}++ if defined $res;
        }
    }

    @ipAddr = @{ $ipAdresses->{decimal} };
    if ( scalar @ipAddr > 0 ){
        foreach my $ip ( @ipAddr ) {

            my $res = DecimalIpToDecimal( $ip );
            $IP{$res}++;
        }
    }

    @ipAddr = @{ $ipAdresses->{dottedDecimal} };
    if ( scalar @ipAddr > 0 ){
        foreach my $ip ( @ipAddr ) {

            $IP{$ip}++;
        }
    }

    @ipAddr = @{ $ipAdresses->{dottedOctal} };
    if ( scalar @ipAddr > 0 ){
        foreach my $ip ( @ipAddr ) {

            my $res = DottedOctalIpToDecimal( $ip );
            $IP{$res}++;
        }
    }

    @ipAddr = @{ $ipAdresses->{dottedHexadecimal} };
    if ( scalar @ipAddr > 0 ){
        foreach my $ip ( @ipAddr ) {

            my $res = DottedHexaDecimalIpToDecimal( $ip );
            $IP{$res}++;
        }
    }
    @ipAddr = @{ $ipAdresses->{hexadecimal} };
    if ( scalar @ipAddr > 0 ){
        foreach my $ip ( @ipAddr ) {

            my $res = HexaDecimalIpToDecimal( $ip );
            $IP{$res}++;
        }
    }

#print Dumper \%IP;
    return \%IP;
} ## --- end sub GetIPs

sub HexaDecimalIpToDecimal {
    my	( $ipAdress )	= @_;
    if ( $ipAdress =~ /^0{1}x{1}/ ){
        $ipAdress =~ s/^0{1}x{1}//;
    }
    my @arr = split //,$ipAdress;
    my $resInBin = "";
    foreach my $d ( @arr ) {
        my $bin = sprintf ( "%04b",hex($d) );
        $resInBin .= $bin;
    }
    my @resultInBin = split //,$resInBin;
    my $result = BinaryIpToDecimal( \@resultInBin ); 
    return $result;
} ## --- end sub HexaDecimalIpToDecimal

sub DottedHexaDecimalIpToDecimal {
    my	( $ipAdress )	= @_;

    my @digits = split /\./,$ipAdress;
    my @result = ();
    foreach my $digit ( @digits ) {
        push @result, oct( $digit );
    }
    
    return join ".",@result;
} ## --- end sub DottedHexaDecimalIpToDecimal

sub DottedOctalIpToDecimal {
    my	( $ipAdress )	= @_;
    my @digits = split /\./,$ipAdress;
    my @result = ();
    foreach my $digit ( @digits ) {
        push @result, OctalToBinary( $digit );
    }
    return join ".",@result;
} ## --- end sub DottedOctalIpToDecimal

sub DottedBinaryIpToDecimal {
    my	( $ipAdress )	= @_;
    my @digits = split /\./,$ipAdress;
    my @result = ();

    foreach my $digit ( @digits ) {
        my $dec = BinaryToDecimal( $digit );
        push @result,$dec;
    }
    return join ".",@result;
} ## --- end sub DottedBinaryIpToDecimal

sub OctalIpToDecimal {
    my	( $ipAdress )	= @_;
    
return undef if ( $ipAdress > 037777777777 );
#$DB::single = 2;
    my $dec = oct( $ipAdress );
    my $bin = DecimalToBinary( $dec );
    my @binIp = split //,$bin;
    my $res = BinaryIpToDecimal( \@binIp );

    return $res;
} ## --- end sub OctalToBinary

sub BinaryIpToDecimal {
    my	( $ipAdress )	= @_;

    my @result = ();
    my $current = "";
    for ( my $i = 0; $i <= $#{ $ipAdress }; $i++ ) {
        $current .= $ipAdress->[$i];
        if ( $i == 7 || $i == 15 || $i == 23 ){
            push @result, BinaryToDecimal( $current );
            $current = "";
        }
    }
    push @result,BinaryToDecimal( $current );
    return join ".",@result;
} ## --- end sub BinaryIpToDecimal


sub DecimalIpToDecimal {
    my	( $ipAdress )	= @_;

    my $bin = DecimalToBinary( $ipAdress );
    my @arr = split //,$bin;
    my $res = BinaryIpToDecimal( \@arr );
    return $res;
} ## --- end sub DecimalIpToDecimal











sub BinaryToDecimal {
    my	( $bin )	= @_;

    return unpack( "N",pack ("B32", substr("0" x 32 . $bin,-32 )));
} ## --- end sub BinaryToDecimal

sub DecimalToBinary {
    my	( $dec )	= @_;
    my $bin = sprintf( "%b",$dec );
    return $bin;
} ## --- end sub DecimalToBinary

sub OctalToBinary {
    my	( $octal )	= @_;

    if ( $octal =~ /^0/ ){
        $octal =~ s/^0//;
    }
    my $res = oct ( $octal );
    return $res;
} ## --- end sub OctalToBinary

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
