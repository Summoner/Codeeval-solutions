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
	push @list,[split /;/,$_];
	
}
close $input;




foreach my $arr_ref (@list){

    my %hash = ();
    foreach my $elem ( @$arr_ref ) {

        my @temp = split /-/,$elem;
		$hash{$temp[0]} = $temp[1];

    }
#	print Dumper \%hash;
	
	print deep(\%hash,"BEGIN"),"\n";
	
}
#print check(\%hash,"BEGIN",\%for_loops);
sub deep{

	my ($hash,$key) = @_;
	return "BAD\n" unless  exists $hash->{$key};

         if ($hash->{$key} eq "END"){

            delete $hash->{$key};
            if(scalar keys %$hash == 0){

                return "GOOD\n";

            }else{
            
               return "BAD\n";

            }
         }
    
   my  $next_key = $hash->{$key};
   delete $hash->{$key};

	deep($hash,$next_key);
}


my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
