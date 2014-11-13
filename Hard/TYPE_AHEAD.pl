#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper; 
use Benchmark;

my $t0 = new Benchmark;

  open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
  #open my $result, ">/home/fanatic/Summoner/Codeeval-solutions/output1.txt" || die "Can't open file: $!\n";

my @list = (); 

	while(<$input>){
    	chomp;
       
	    push @list,[split ",",$_];
	}
close $input;


my $str = "Mary had a little lamb its fleece was white as snow;
And everywhere that Mary went, the lamb was sure to go.
It followed her to school one day, which was against the rule;
It made the children laugh and play, to see a lamb at school.
And so the teacher turned it out, but still it lingered near,
And waited patiently about till Mary did appear.
Why does the lamb love Mary so? the eager children cry; Why, Mary loves the lamb, you know the teacher did reply ";

my @str = ();
my @words = ();
my %words_count = ();
my $all_indexes = {};
   @str = split /\s+/,$str;

for ( my $i = 0; $i <= $#str; $i++ ){
       
    $str[$i] =~ /([a-zA-Z]+)/;
    my $word = $1;
    push @words,$word;
    $words_count{ $word }++;
 }

foreach my $arr ( @list ) {

    print calc( $arr->[0]-1,$arr->[1] ),"\n";
}


sub build_indexes {
    my	( $n )	= @_;
    my $indexes = {};        
    for ( my $i=0; $i < scalar @words - $n; $i += $n ) {

        my $key = join " ",@words[$i..$i+$n-1];
        my $value = $words[$i+$n];
           $indexes->{$key}{$value}++;
    }
return $indexes;
} ## --- end sub build_indexes

sub calc {
    my	( $n,$word )	= @_;

    my @result = ();
    unless( defined $all_indexes->{$n}){
    
        $all_indexes->{$n} = build_indexes( $n );    
    }
#$DB::single = 2;

    my $total = $words_count{$word};
    return "" if ( $total == 0 );
    my %next_words = %{ $all_indexes->{$n}->{$word} };

    foreach my $next_word ( keys %next_words ) {

        my $val = $next_words{$next_word} / $total;

        $val = sprintf( "%.3f",$val );

        push @result, [ $next_word,$val ];
    }
    
     my @final = map{ $_->[0] . "," . $_->[1] } sort{ $b->[1] <=> $a->[1] || $a->[0] cmp $b->[0] }@result;
    return join ";",@final;
} ## --- end sub calc




my $t1 = new Benchmark;
my $td = timediff($t1, $t0);
print "the code took:",timestr($td),"\n";
