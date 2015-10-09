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

#print Dumper \@list;

foreach my $arr ( @list ) {
    my $accessTable = FormAccessTable();

    my $executePossible = Calc( $arr,$accessTable );

    if ( $executePossible ){
        print "True\n";
    }else{
        print "False\n";
    }
}

sub Calc {
    my	( $arr,$accessTable )	= @_;

    my $executeCommandPossible = 1;

    foreach my $element ( @$arr ) {

        my @command = split /\=\>/,$element;
        $executeCommandPossible = ExecuteCommandPossible( $accessTable,\@command );
        last unless ( $executeCommandPossible );
    }
    return $executeCommandPossible;
} ## --- end sub Calc

sub ExecuteCommandPossible {
    my	( $accessTable,$command )	= @_;

    my $executePossible = 0;
    my $userFrom = shift @$command;
    
    my $fileName = shift @$command;

    my $avaiableCommands = $accessTable->{$userFrom}->{$fileName};

    my $commandName = shift @$command;

    if ( defined $avaiableCommands && exists $avaiableCommands->{$commandName} ){

        $executePossible = 1;
        if ( $commandName eq "grant" && scalar @$command > 0 ){

            $commandName = shift @$command;
            my $userTo = shift @$command;
            my $possibleCommands = $accessTable->{$userTo}->{$fileName};
               $possibleCommands->{$commandName} = 1;
               $accessTable->{$userTo}->{$fileName} = $possibleCommands;
        }
    }
    return $executePossible;
} ## --- end sub ExecuteCommand




sub FormAccessTable {
    my $table = {};

    $table->{user_1}->{file_1}->{read} = 1;
    $table->{user_1}->{file_1}->{write} = 1;
    $table->{user_1}->{file_1}->{grant} = 1;

    $table->{user_1}->{file_2}->{read} = 1;
    $table->{user_1}->{file_2}->{grant} = 1;

    $table->{user_1}->{file_3} = undef;


    $table->{user_2}->{file_1}->{read} = 1;
    $table->{user_2}->{file_1}->{write} = 1;

    $table->{user_2}->{file_2}->{write} = 1;

    $table->{user_2}->{file_3}->{read} = 1;

    $table->{user_3}->{file_1}->{read} = 1;
    $table->{user_3}->{file_1}->{grant} = 1;

    $table->{user_3}->{file_2}->{grant} = 1;

    $table->{user_3}->{file_3}->{read} = 1;
    $table->{user_3}->{file_3}->{grant} = 1;

    $table->{user_4}->{file_1}->{write} = 1;
    $table->{user_4}->{file_1}->{grant} = 1;


    $table->{user_4}->{file_2}->{read} = 1;
    $table->{user_4}->{file_2}->{write} = 1;
    $table->{user_4}->{file_2}->{grant} = 1;

    $table->{user_4}->{file_3}->{grant} = 1;

    $table->{user_5}->{file_1}->{read} = 1;
    $table->{user_5}->{file_1}->{write} = 1;

    $table->{user_5}->{file_2} = undef;

    $table->{user_5}->{file_3}->{write} = 1;

    $table->{user_6}->{file_1}->{read} = 1;

    $table->{user_6}->{file_2}->{write} = 1;

    $table->{user_6}->{file_3}->{read} = 1;
    $table->{user_6}->{file_3}->{write} = 1;

    return $table;
} ## --- end sub FormAccessTable

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
