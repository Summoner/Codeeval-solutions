#!/usr/bin/perl -w
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
	push @list,$_;
	
}
close $input;
my %hash = ();
my %for_loops = ();
foreach(@list){
	my @temp = split /;/,$_;
	   %hash = ();
	   %for_loops = ();
	foreach(@temp){
		my @temp1 = split /-/,$_;
		$hash{$temp1[0]} = $temp1[1];
	}
	print check(\%hash,"BEGIN",\%for_loops);
	
}
#print Dumper \%hash;
#print check(\%hash,"BEGIN",\%for_loops);
sub check{

	my ($hash_ref,$key,$for_loops) = @_;

	return "GOOD\n" if $hash_ref->{$key} eq "END";
	return "BAD\n" if exists $for_loops->{$hash_ref->{$key}};
    $for_loops->{$key}++;
	check($hash_ref,$hash_ref->{$key},$for_loops);
}


my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
