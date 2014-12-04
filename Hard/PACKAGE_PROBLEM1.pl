#!/usr/bin/perl -w

use strict;
use warnings;
use Data::Dumper; 


open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
#open my $output, ">/home/fanatic/Summoner/Codeeval-solutions/output.txt" || die "Can't open file: $!\n";


my @list = ();

while(<$input>){
	
	chomp;
	push @list, [split /:/,$_];
	
}
close $input;

my @arr = ();
foreach my $arr_ref (@list ) {

    $arr_ref->[1] =~ s/\s+\(//g;
    $arr_ref->[1] =~ s/\)/,/g;
    $arr_ref->[1] =~ s/\$//g;
    my $max_cap = $arr_ref->[0] * 100;
    my $str = join ",",$max_cap,$arr_ref->[1];
    push @arr,[split /,/,$str]; 
}

#print Dumper \@arr;



my $count = 0;
my $index = 0;
my $indexes = [];
my $weight = 0;
my $weights = [];
my $value = 0;
my $values = [];

foreach my $arr_ref(@arr) {

    my $W = shift @$arr_ref;
    
    foreach (@$arr_ref){
                
        $count++;

        $index = $_ if ($count == 1);
        $weight = $_ * 100 if ($count == 2);
         if ($count == 3){
            
                $value = $_;
                               
                push @$indexes, $index;
                push @$weights, $weight;
                push @$values,$value;

                $count = 0;
         }
    }
#print Dumper \$indexes;
#print Dumper \$weights;
#print Dumper \$values;
 
unshift @$values,0;
unshift @$weights,0;

my $arr = find_max_pack($values,$weights,scalar @$values,$W);

if (scalar @$arr > 0){

    print join (",",@$arr),"\n"; 

}else{
    print "-\n";
}
}

sub find_max_pack {
    my	( $values,$weights,$n,$capasity )	= @_;
    
    my $m_v = [];
    my $m_i = [];
    my $m_w = [];

    
    for ( my $i=0; $i < $n; $i++) {

        for ( my $j=0; $j <= $capasity; $j++) {

            $m_v->[$i]->[$j] = 0;
            $m_i->[$i]->[$j] = [];
            $m_w->[$i]->[$j] = 0;
        }
    }

#$DB::single=2;


    for ( my $i=1; $i < $n; $i++  ) {

        for ( my $j=1; $j <= $capasity; $j++ ) {
            
            if ($j >= $weights->[$i]){
            
                my $v_incl = $m_v->[$i-1]->[$j-$weights->[$i]] + $values->[$i];

                if ($v_incl > $m_v->[$i-1]->[$j]){
                
                   $m_v->[$i]->[$j] = $v_incl;
                   push @{ $m_i->[$i]->[$j] }, @{ $m_i->[$i-1]->[$j-$weights->[$i]] };
                   push @{ $m_i->[$i]->[$j] }, $i;
                   
                }else{
                
                    $m_v->[$i]->[$j] =  $m_v->[$i-1]->[$j];  
                    $m_i->[$i]->[$j] =  $m_i->[$i-1]->[$j]; 
                }
            
            }else{
            
                 $m_v->[$i]->[$j] =  $m_v->[$i-1]->[$j];  
                 $m_i->[$i]->[$j] =  $m_i->[$i-1]->[$j];
            
            }

        }
    }
my $max_val = $m_v->[$n-1]->[$capasity];

#show_arr( $m_i );
#print "\n";
#show_arr( $m_v );

for ( my $i=0;$i <= $capasity;$i++) {

    return $m_i->[$n-1]->[$i] if ($m_v->[$n-1]->[$i] == $max_val);
}

} ## --- end sub find_max_pack

sub show_arr {
    my	( $arr ) = @_;


    for ( my $i=0;$i <= $#{$arr};$i++ ) {


        for ( my $j=0;$j <= $#{$arr->[$i]} ;$j++ ) {

                print "$arr->[$i]->[$j]\t";
        }
        print "\n";
    }
    return ;
} ## --- end sub show_arri


