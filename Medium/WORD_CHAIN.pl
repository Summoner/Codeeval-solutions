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
	push @list,[split /,/,$_];
	}
close $input;

#print Dumper \@list;

foreach my $str (@list){

    calc($str);
}



sub calc {
    my	( $str )	= @_;
    my @result = ();
    my $count = 1;
    while ($count <= scalar @$str){
     
        my @arr1 = @$str;    
        my $arr2 = [];
        my $last = get_last($str->[0]);
        push @$arr2, shift @arr1;
        deep($last,\@arr1,$arr2);
        push @result, scalar @$arr2;

        push @$str, shift @$str;
    $count++;
    }

    # print Dumper \@result;
    
    my @sorted = sort{$b<=>$a}@result;
    if ($sorted[0] == 1){
    
        print "None\n";
    }else{
        print "$sorted[0]\n";
    }

} ## --- end sub calc




sub deep {
    my	( $last,$arr1,$arr2 )	= @_;

    my $j = -1;
    return scalar @$arr2 if (scalar @$arr1 == 0);
    
    foreach my $i (0..$#{$arr1} ) {

        my $first = get_first($arr1->[$i]);

        if ($last eq $first){
            
            $j = $i;
            $last = get_last($arr1->[$i]);
            last;
        }

    }
    
unless ($j == -1){

    push @$arr2,splice( @$arr1, $j, 1);
    deep($last,$arr1,$arr2);

}else{

    return scalar @$arr2;

}

} ## --- end sub deep1




sub get_first {
    my	( $str )	= @_;

    return substr($str, 0,1) ;
} ## --- end sub get_first

sub get_last {
    my	( $str )	= @_;

    return substr ($str,-1);
} ## --- end sub get_last


my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
