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
	push @list,[split /\s+/,$_];
	
}
close $input;

my $root;

insert($root,30);
insert($root,8);
insert($root,52);
insert($root,3);
insert($root,20);
insert($root,10);
insert($root,29);

#print Dumper \$root;
foreach (@list){
	
	my @sorted = sort {$a<=>$b}@$_;

	my $tree = lca($root,$sorted[0],$sorted[1]);
	
	print $tree->{VALUE},"\n";
	
}

sub lca{

	my ($root,$n1,$n2) = @_;
	return unless defined $root;

	if ($root->{VALUE} > $n1 && $root->{VALUE} > $n2){

		return lca($root->{LEFT},$n1,$n2);
	}
	if ($root->{VALUE} < $n1 && $root->{VALUE} < $n2){

		return lca($root->{RIGHT},$n1,$n2);
	}

	return $root;
}

sub insert{
	my ($tree,$value) = @_;
	unless ($tree){
		
		$tree = {};
		$tree->{VALUE} = $value;
		$tree->{LEFT} = undef;
		$tree->{RIGHT} = undef;
		$_[0] = $tree;
		return;
	}

	if ($tree->{VALUE} > $value){

		insert($tree->{LEFT},$value);

	}elsif ($tree->{VALUE} < $value){

		insert($tree->{RIGHT},$value);

	}else{
		warn "Duplicate insert of $value\n";
	}

}

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
