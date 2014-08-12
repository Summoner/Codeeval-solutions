#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper; 
use Benchmark;

my $t0 = new Benchmark;
open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
#open my $result, ">/home/fanatic/Summoner/Codeeval-solutions/output.txt" || die "Can't open file: $!\n";

my @list = ();

while(<$input>){
	
	chomp $_;
	push @list,[split //,$_];
	
}
close $input;

#print Dumper \@list;
foreach my $arr(@list){

	#print scalar @$arr;
	convert($arr);

}

#convert();
sub convert{

my $arr_ref = shift;

my %pattern = (
	j => "u",
	p => "v",
	t => "r",
	m => "x",
	" " =>" ",
	w => "t",
	u => "j",
	l => "m",
	k => "o",
	f => "w",
	c => "f",
	b => "n",
	v => "g",
	n => "s",
	a => "y",
	q => "z",
	e => "c",
	s => "d",
	r => "p",
	d => "i",
	z => "q",
	h => "b",
	y => "a",
	o => "e",
	i => "k",
	g => "l",
	x => "h"
	);
my @result = ();
my %reverse_pattern = reverse %pattern;
foreach (@$arr_ref){

	push @result, $reverse_pattern{$_};

}
print @result,"\n";
#print join " ",sort keys %pattern,"\n";
#print join " ",sort keys %reverse_pattern,"\n";
}


my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
