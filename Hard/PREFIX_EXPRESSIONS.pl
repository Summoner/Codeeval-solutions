#!/usr/bin/env perl -w
use strict;
use warnings;
use utf8;
use Data::Dumper; 

open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
# open my $result, ">D:\\Perl\\output.txt" || die "Can't open file: $!\n";

my @list = ();

while(<$input>){
	
	chomp;
	push @list,[split /\s+/,$_];
	
}
close $input;

foreach my $arr (@list ) {

    print eval_expr($arr),"\n";
}

sub eval_expr{

    my $arr_ref = shift;
    my %operators = ();
    $operators{"*"} = 1;
    $operators{"/"} = 1;
    $operators{"+"} = 1;
    $operators{"-"} = 1;

    my @stack = ();
    
    for(my $i = $#{$arr_ref}; $i >= 0; $i--) {

        unless (exists $operators{$arr_ref->[$i]}){

                push @stack,$arr_ref->[$i];
        }else{
                my $op1 = pop @stack;
                my $op2 = pop @stack;
                my $res = eval "$op1 $arr_ref->[$i] $op2";
                push @stack, $res;
        }

    }
   return $stack[0];
}


