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
	push @list, [split /;/,$_];
	
}
close $input;

foreach my $arr_ref (@list){	
		 
	my $u1 = $arr_ref->[0];
    my $u2 = $arr_ref->[1];
   compare($u1,$u2);
}


sub compare {
    my	( $u1,$u2 )	= @_;

    $u2 =~ /^(?<scheme>[^:]+):\/\/(?<host>[^:\/]+)(:(?<port>\d+)?)?(?<path>\/.*)?$/x;

    print "scheme: $+{scheme}\n" if defined($+{scheme});
    print defined($+{host}) ? "host: $+{host}\n" : "undef\n";
    print defined($+{port}) ? "port: $+{port}\n" : "80\n";
    print "path: $+{path}\n" if defined($+{path});



    return ;
} ## --- end sub compare
my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
