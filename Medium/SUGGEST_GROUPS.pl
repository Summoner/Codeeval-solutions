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
	push @list,[split /:/,$_];
	}
close $input;

my %users_friends = ();
my %groups_users = ();
my %users_groups = ();

foreach my $arr_ref (@list){

    $users_friends{$arr_ref->[0]} = [split /,/,$arr_ref->[1]];

    if ( defined $arr_ref->[2] ){

        my @groups = split /,/,$arr_ref->[2];

        $users_groups{$arr_ref->[0]} = \@groups;

        foreach my $group ( @groups ) {

            push @{$groups_users{$group}},$arr_ref->[0];
        }
    }

}

my %suggested_groups = ();
foreach my $user ( keys %users_friends ) {

    foreach my $group ( keys %groups_users ) {
        
        next if ( is_inGroup($user,$group) );

        if ( compare($groups_users{$group},$users_friends{$user}) ) {
        
           push @{$suggested_groups{$user}},$group;
        }
    }
}


foreach my $user ( sort { $a cmp $b }keys %suggested_groups ) {

    print "$user:",join (",", sort { $a cmp $b} @{$suggested_groups{$user}}),"\n";
}

sub compare {
    my	( $users_in_groups,$friends )	= @_;

    my %hash1 = ();


    foreach my $user ( @$users_in_groups ) {

        $hash1{$user}++;
    }

    my $count = 0;
    foreach my $user ( @$friends ) {

        $count++ if (exists $hash1{$user});
    }
    
    my $percent = ($count * 100)/scalar @$friends; 
    return 1 if ($percent >= 50);
    return 0;
} ## --- end sub compare



sub is_inGroup {
    my	( $user,$group )	= @_;
    
    return 0 unless ( exists $users_groups{$user});
    my @groups = @{$users_groups{$user}};

    my $in_group = 0;


    foreach my $gr (  @groups ) {

       if ($gr eq $group){

            $in_group = 1;
            last
       }
    }
    return $in_group;
} ## --- end sub is_inGroup

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
