#!/usr/bin/perl -w

use strict;
use warnings;
use Data::Dumper; 


open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
# open my $result, ">D:\\Perl\\output.txt" || die "Can't open file: $!\n";

my @list = ();
while(<$input>){
	
	chomp;
	push @list,[split / /,$_];
	
}
close $input;


foreach my $arr_ref ( @list ) {
    
    my $hash = {};
    $hash->{value} = $arr_ref->[0];

    # $DB::single = 2;
    my $is_loop = 0;
    for my $i (1..$#{$arr_ref} ) {

       $is_loop = insert($hash,$arr_ref->[$i]);
         last if ($is_loop);
                 
    }

#print Dumper \$hash;
          

    my $loop_elements = [];
    my $res = [];
    # $DB::single = 2;
     find_loop($hash,$hash,$loop_elements,-1);
    $res = get_loop_values($arr_ref,$loop_elements);
     print join (" ",@$res),"\n";

    #print Dumper \$hash;
}


sub get_loop_values {
    my	( $arr_ref,$loop_elements )	= @_;

    my %indexes = ();
    my @indexes = ();
    my $result = [];

    foreach my $i (0..$#{$arr_ref} ) {

        $indexes{$arr_ref->[$i]} = $i;
    }

    foreach (@$loop_elements){

       push @indexes, $indexes{$_};    
    
    }


    foreach my $index (sort {$a <=> $b} @indexes ) {
    
        push @$result, $arr_ref->[$index];

    }
    return $result;
} ## --- end sub get_loop_values

sub get_node {
    my	( $node,$val )	= @_;

    return $node if ($val == $node->{value});

    my $step = $node;
    my $result = undef;    
    while(defined $step->{next}){
       
        $step = $step->{next};
        if ( $val == $step->{value}){
                
                $result = $step;
                last;
        }        
    }
    return $result;
} ## --- end sub get_node



sub find_loop {
    my	( $smal_step,$big_step,$res,$count ) = @_;
    
   if ($count == 2){
       
        my $temp = shift @$res;

        push @$res,$temp;
        return $res;

   }elsif($count == 1){
   
        push @$res,$smal_step->{value};
   
   }
        
       my $small_value = $smal_step->{value};
       my $big_value = $big_step->{value};

          $count++ if ($small_value == $big_value);

      $smal_step = $smal_step->{next};
      $big_step = $big_step->{next}->{next};

      find_loop($smal_step,$big_step,$res,$count);

    
    
    
} ## --- end sub is_loop



















sub insert {
    my	( $node,$val ) = @_;

   my $is_loop = 0;
    
   my $current_node = get_node($node,$val);

    if (defined $current_node){

        $is_loop = 1; 
    }else{
    
       $current_node->{value} = $val;

    }

    my $step = $node;
    while (defined $step->{next} ){
    
        $step = $step->{next};
    
    }
   $step->{next} = $current_node;
   return $is_loop;
       
} ## --- end sub insert
