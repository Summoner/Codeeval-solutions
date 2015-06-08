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
	    push @list,[split /\s+/,$_];
	}
close $input;

#print Dumper \@list;

my @operationsComb = getOperationsCombinations();
#print Dumper \@operationsComb;
foreach my $str (@list){

   my $result = process($str);
   if ( $result == 42 ){
       print "YES\n";   
   }else{
        print "NO\n";
   }
}

sub process {
    my	( $arr )	= @_;
    my @indexes = ( 0..scalar @$arr-1 );
    my $result = 0;
    while( scalar @indexes > 0 ){
        #print join " ",@indexes,"\n";
        $result = calc42( $arr,\@indexes );
        last if ( $result == 42 );
        @indexes = getNextPerm( @indexes );
    }
    return $result;
} ## --- end sub calc

sub calc42 {
    my	( $digits, $indexes )	= @_;
    my $result = 0;
#    $DB::single = 2;
    foreach my $operationsStr ( @operationsComb ) {

        my @operationsList = split //,$operationsStr;
        $result = eval "
            $digits->[ $indexes->[0] ] 
            $operationsList[0]
            $digits->[ $indexes->[1] ]
            $operationsList[1]
            $digits->[ $indexes->[2] ] 
            $operationsList[2]
            $digits->[ $indexes->[3] ] 
            $operationsList[3] 
            $digits->[ $indexes->[4] ] ";

            # print $result."------------>".$digits->[ $indexes->[0] ]." ".$operationsList[0]." ".$digits->[ $indexes->[1] ]." ".$operationsList[1]." ".$digits->[ $indexes->[2] ]." ".$operationsList[2]." ".$digits->[ $indexes->[3] ]." ".$operationsList[3]." ".$digits->[ $indexes->[4] ], "\n";
        last if ( $result == 42 );
    }
    return $result;
}

sub getOperationsCombinations {
    my	( $par1 )	= @_;
	my @operations = ('*','+','-','-');
	my @data = ();
	my %result = ();

	RecurPerm(\@operations,\@data,$#operations,0,\%result);
	return sort {$a cmp $b} keys %result;
} ## --- end sub getOperationsCombinations

sub RecurPerm{
	my ( $str,$data,$last,$index,$result ) = @_;
	my $len = scalar @{$str};

	for( my $i = 0; $i < $len; $i++ ){
		$data->[$index] = $str->[$i];
		if ($index == $last){
		    $result->{join "",@{$data}}++;
		}else{
			RecurPerm( $str,$data,$last,$index+1,$result );
		}
	}
    return ;
} ## --- end sub calc42

sub getNextPerm{

	my ( @perm )  = @_;
	my $nextExist = 0;

	for (my $k = 0; $k < scalar @perm -1; $k++){
		if ($perm[$k] < $perm[$k + 1]){
			$nextExist = 1;
		}
	}

	unless( $nextExist ){
	    return @perm = ();
	}

	my $N = scalar @perm;
	my $i = $N - 1;

	while( $perm[$i-1] >= $perm[$i] ){
		$i = $i - 1;
	}
	my $j = $N;

	while( $perm[$j-1] <= $perm[$i-1] ){
 		$j = $j -1;
	}
	# swap values at position i-1 and j-1
    swap( $i-1, $j-1, \@perm );
    $i++;
    $j = $N;
    while($i < $j){
        #Swap values at position i-1 and j-1
        swap($i - 1, $j - 1, \@perm);
        $i++;
        $j--;
    }
    return @perm;
}

sub swap{
    my ( $i,$j,$permRef )  = @_;

    ( $permRef->[$i],$permRef->[$j] ) = ( $permRef->[$j],$permRef->[$i] );
}

my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
