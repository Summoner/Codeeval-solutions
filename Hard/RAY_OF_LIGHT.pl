#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper;
use Benchmark;
use Storable qw( dclone );

my $t0 = new Benchmark;

  open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
 #open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";

my @list = ();

	while(<$input>){
    	chomp;
	    push @list,[split //,$_];

	}
close $input;


my $elements = {};
my $trajectories = {};

$elements->{WALL} = "#";
$elements->{COLUMN} = "o";
$elements->{PRISM} = "*";
$elements->{EMPTY} = " ";
$elements->{LIGHT_CROSS} = "X";
$elements->{LIGHT_BACK} = "\\";
$elements->{LIGHT_FORWARD} = "/";

$trajectories->{UP_L} = 0;
$trajectories->{DN_L} = 1;
$trajectories->{UP_R} = 2;
$trajectories->{DN_R} = 3;

foreach my $arr ( @list ) {

    my $matrix = [];
    $matrix = create_matrix( $matrix,$arr );
    #show_matrix($matrix);
    $matrix = spread_light( $matrix );
    show_matrix1( $matrix );
}


sub spread_light {
    my	( $matrix )	= @_;
    #  $DB::single = 2;
    my $rays = [];

    my $ray = {};
    $ray->{position} = find_input_point($matrix);
    $ray->{trajectory} = find_initial_trajectory($matrix,$ray->{position});
    $ray->{light_power} = 20;

    push @$rays, $ray;

    while (scalar @$rays > 0 ){

        $rays =  _spread_light($rays,$matrix);

    }
    return $matrix;
} ## --- end sub spread_light


sub _spread_light {
    my	( $rays,$matrix )	= @_;

    my $result = [];

    foreach my $ray ( @$rays ) {

        my $new_rays = [];
        my $next_position = next_position( $ray->{position},$ray->{trajectory} );
        my $i = 0;
        my $j = 0;
        my $trajectory = -1;
        next unless in_room( $next_position );
        my $next_element = $matrix->[$next_position->{i}]->[$next_position->{j}];

        if ( $next_element eq $elements->{WALL} ){

            unless (in_corner( $next_position ) ){

                if ( $next_position->{j} == 0 ){

                    $i = $next_position->{i};
                    $j = $next_position->{j} +1;
                    $trajectory = reflect_vertically( $ray->{trajectory} );

                } elsif ( $next_position->{j} == 9 ){

                    $i = $next_position->{i};
                    $j = $next_position->{j} -1;
                    $trajectory = reflect_vertically( $ray->{trajectory} );

                }elsif ( $next_position->{i} == 0 ){

                    $i = $next_position->{i}+1;
                    $j = $next_position->{j};
                    $trajectory = reflect_horisontally( $ray->{trajectory} );

                } if ( $next_position->{i} == 9 ){

                    $i = $next_position->{i} - 1;
                    $j = $next_position->{j};
                    $trajectory = reflect_horisontally( $ray->{trajectory} );
                }

                $next_position->{i} = $i;
                $next_position->{j} = $j;

                set_new_element( $next_position,$trajectory,$matrix );

                my $new_ray = {};
                $new_ray->{position} = $next_position;
                $new_ray->{trajectory} = $trajectory;
                $new_ray->{light_power} = $ray->{light_power}-1;
                push @$new_rays, $new_ray;

            }
        }elsif( $next_element eq $elements->{COLUMN} ){

            next;

        }elsif( $next_element eq $elements->{PRISM} ){
            # $DB::single = 2;

            my $new_trajectories = dclone($trajectories);
            my $trajectory_for_del = reverse_trajectory( $ray->{trajectory} );

            foreach my $tr ( keys %{$new_trajectories} ) {

                if ( $new_trajectories->{$tr} == $trajectory_for_del ){

                    delete $new_trajectories->{$tr};
                    last;
                }
            }

            foreach my $trajectory ( values %{$new_trajectories} ) {

                my $new_ray = {};
                $new_ray->{position} = $next_position;
                $new_ray->{trajectory} = $trajectory;
                $new_ray->{light_power} = $ray->{light_power}-1;
                push @$new_rays, $new_ray;
            }

        }elsif( $next_element eq " " || $next_element eq $elements->{LIGHT_CROSS} ||
                $next_element eq $elements->{LIGHT_BACK} || $next_element eq $elements->{LIGHT_FORWARD}){

                my $new_ray = {};
                $new_ray->{position} = $next_position;
                $new_ray->{trajectory} = $ray->{trajectory};
                $new_ray->{light_power} = $ray->{light_power}-1;
                push @$new_rays, $new_ray;
                set_new_element($next_position,$ray->{trajectory},$matrix);
        }


        foreach my $ray ( @$new_rays ) {

            push @$result,$ray if ( $ray->{light_power} > 0 );
        }
    }

    return $result;
} ## --- end sub _spread_light

sub set_new_element {
    my	( $next_position,$trajectory,$matrix )	= @_;

    if ( $trajectory == $trajectories->{UP_L} || $trajectory == $trajectories->{DN_R} ){

        if ( $matrix->[$next_position->{i}]->[$next_position->{j}] eq " " ){

            $matrix->[$next_position->{i}]->[$next_position->{j}] = "\\";

        }elsif ( $matrix->[$next_position->{i}]->[$next_position->{j}] eq "\\" ){

            $matrix->[$next_position->{i}]->[$next_position->{j}] = "\\";

        }elsif ( $matrix->[$next_position->{i}]->[$next_position->{j}] eq "X" ){

            $matrix->[$next_position->{i}]->[$next_position->{j}] = "X";

        }elsif ( $matrix->[$next_position->{i}]->[$next_position->{j}] eq "/" ){

            $matrix->[$next_position->{i}]->[$next_position->{j}] = "X";
        }

    }else{

        if ( $matrix->[$next_position->{i}]->[$next_position->{j}] eq " " ){

            $matrix->[$next_position->{i}]->[$next_position->{j}] = "/";

        }elsif ( $matrix->[$next_position->{i}]->[$next_position->{j}] eq "/" ){

            $matrix->[$next_position->{i}]->[$next_position->{j}] = "/";

        }elsif ( $matrix->[$next_position->{i}]->[$next_position->{j}] eq "X" ){

            $matrix->[$next_position->{i}]->[$next_position->{j}] = "X";

        }elsif ( $matrix->[$next_position->{i}]->[$next_position->{j}] eq "\\" ){

            $matrix->[$next_position->{i}]->[$next_position->{j}] = "X";
        }
    }
} ## --- end sub set_new_element

sub reverse_trajectory {
    my	( $trajectory )	= @_;
    return $trajectories->{UP_R} if ( $trajectory == $trajectories->{DN_L} );
    return $trajectories->{UP_L} if ( $trajectory == $trajectories->{DN_R} );
    return $trajectories->{DN_L} if ( $trajectory == $trajectories->{UP_R} );
    return $trajectories->{DN_R} if ( $trajectory == $trajectories->{UP_L} );

} ## --- end sub reverse_trajectory

sub reflect_horisontally {
    my	( $trajectory )	= @_;

    return $trajectories->{UP_R} if ( $trajectory == $trajectories->{DN_R} );
    return $trajectories->{UP_L} if ( $trajectory == $trajectories->{DN_L} );
    return $trajectories->{DN_L} if ( $trajectory == $trajectories->{UP_L} );
    return $trajectories->{DN_R} if ( $trajectory == $trajectories->{UP_R} );

} ## --- end sub reflect_horisontally

sub reflect_vertically {
    my	( $trajectory )	= @_;

    return $trajectories->{DN_L} if ( $trajectory == $trajectories->{DN_R} );
    return $trajectories->{DN_R} if ( $trajectory == $trajectories->{DN_L} );
    return $trajectories->{UP_L} if ( $trajectory == $trajectories->{UP_R} );
    return $trajectories->{UP_R} if ( $trajectory == $trajectories->{UP_L} );

} ## --- end sub reflect_vertically

sub in_corner {
    my	( $position )	= @_;

    return 1 if ( $position->{i} == 0 && $position->{j} == 0 ||
                  $position->{i} == 0 && $position->{j} == 9 ||
                  $position->{i} == 9 && $position->{j} == 0 ||
                  $position->{i} == 9 && $position->{j} == 9 );
    return 0;
} ## --- end sub in_corner

sub in_room {
    my	( $position )	= @_;

    return 0 if ( $position->{i} < 0 || $position->{i} > 9 ||  $position->{j} < 0 ||  $position->{j} > 9 );
    return 1;
} ## --- end sub in_room

sub next_position {
    my	( $position,$trajectory )	= @_;

    my $new_position = {};
    if ( $trajectory == $trajectories->{UP_L} ){

        $new_position->{i} = $position->{i}-1; $new_position->{j} = $position->{j}-1;

    }elsif ( $trajectory == $trajectories->{DN_L} ){

        $new_position->{i} = $position->{i}+1; $new_position->{j} = $position->{j}-1;

    }elsif ( $trajectory == $trajectories->{UP_R} ){

        $new_position->{i} = $position->{i}-1; $new_position->{j} = $position->{j}+1;

    }elsif ( $trajectory == $trajectories->{DN_R} ){

        $new_position->{i} = $position->{i}+1; $new_position->{j} = $position->{j}+1;

    }

    return $new_position;
} ## --- end sub next_position

sub find_initial_trajectory {
    my	( $matrix,$point )	= @_;

   return $trajectories->{DN_L} if ( $point->{i} == 0 && $matrix->[$point->{i}]->[$point->{j}] eq $elements->{LIGHT_FORWARD} );
   return $trajectories->{DN_R} if ( $point->{i} == 0 && $matrix->[$point->{i}]->[$point->{j}] eq $elements->{LIGHT_BACK} );

   return $trajectories->{UP_R} if ( $point->{i} == 9 && $matrix->[$point->{i}]->[$point->{j}] eq $elements->{LIGHT_FORWARD} );
   return $trajectories->{UP_L} if ( $point->{i} == 9 && $matrix->[$point->{i}]->[$point->{j}] eq $elements->{LIGHT_BACK} );

   return $trajectories->{UP_R} if ( $point->{j} == 0 && $matrix->[$point->{i}]->[$point->{j}] eq $elements->{LIGHT_FORWARD} );
   return $trajectories->{DN_R} if ( $point->{j} == 0 && $matrix->[$point->{i}]->[$point->{j}] eq $elements->{LIGHT_BACK} );

   return $trajectories->{DN_L} if ( $point->{j} == 9 && $matrix->[$point->{i}]->[$point->{j}] eq $elements->{LIGHT_FORWARD} );
   return $trajectories->{UP_L} if ( $point->{j} == 9 && $matrix->[$point->{i}]->[$point->{j}] eq $elements->{LIGHT_BACK} );

} ## --- end sub find_initial_trajectory

sub find_input_point {
    my	( $matrix )	= @_;

    my $point = {};
    for ( my $j = 0; $j < 10; $j++ ) {

        if ( $matrix->[0]->[$j] eq $elements->{LIGHT_FORWARD} || $matrix->[0]->[$j] eq $elements->{LIGHT_BACK} ){

                $point->{i} = 0;
                $point->{j} = $j;
                return $point;
        }
        if ( $matrix->[9]->[$j] eq $elements->{LIGHT_FORWARD} || $matrix->[9]->[$j] eq $elements->{LIGHT_BACK} ){

                $point->{i} = 9;
                $point->{j} = $j;
                return $point;
        }
    }
    for ( my $i = 0; $i < 10; $i++ ) {

        if ( $matrix->[$i]->[0] eq $elements->{LIGHT_FORWARD} || $matrix->[$i]->[0] eq $elements->{LIGHT_BACK} ){

                $point->{i} = $i;
                $point->{j} = 0;
                return $point;
        }
        if ( $matrix->[$i]->[9] eq $elements->{LIGHT_FORWARD} || $matrix->[$i]->[9] eq $elements->{LIGHT_BACK} ){

                $point->{i} = $i;
                $point->{j} = 0;
                return $point;
        }
    }
} ## --- end sub find_input

sub create_matrix {
    my	( $matrix,$arr )	= @_;

    while ( scalar @$arr > 0 ){

        my $temp = [];
        for ( my $i = 0; $i < 10; $i++)  {

            push @$temp, shift @$arr;
        }
        push @$matrix,$temp;
    }
    return $matrix;
}

sub show_matrix {
    my	( $matrix )	= @_;

    for ( my $i = 0;$i < scalar @$matrix; $i++ ) {

        for ( my $j = 0; $j < scalar @{$matrix->[$i]}; $j++ ) {

            print "$matrix->[$i]->[$j]";
        }
        print "\n";
    }
} ## --- end sub show_matrix

sub show_matrix1 {
    my	( $matrix )	= @_;

    my @temp = ();
    foreach my $arr ( @$matrix ) {

        push @temp, join "",@$arr;
    }

    print join "",@temp,"\n";
} ## --- end sub show_matrix1
my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
