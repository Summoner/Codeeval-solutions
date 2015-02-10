#!/usr/bin/perl -w
#***********************************************************
package Card;

sub new {
    my $class = shift;
    my $self = {@_};
    bless $self,$class;
    return $self;
} ## --- end sub new

sub val {

    $_[0]->{val} = $_[1] if (defined $_[1]); $_[0]->{val};
} ## --- end sub val

sub suit {

    $_[0]->{suit} = $_[1] if (defined $_[1]); $_[0]->{suit};
} ## --- end sub val

#return card_value rating value
sub card_rating {
    my $self = shift;
    my  $card_values = {};
        $card_values->{2} = 1;
        $card_values->{2} = 2;
        $card_values->{3} = 3;
        $card_values->{4} = 4;
        $card_values->{5} = 5;
        $card_values->{6} = 6;
        $card_values->{7} = 7;
        $card_values->{8} = 8;
        $card_values->{9} = 9;
        $card_values->{T} = 10;
        $card_values->{J} = 11;
        $card_values->{Q} = 12;
        $card_values->{K} = 13;
        $card_values->{A} = 14;

    return $card_values->{$self->val};
} ## --- end sub card_rating

#return card_suit digit interpretation
sub count_card_suit {
    my	( $self )	= @_;
    my  $card_suits = {};
        $card_suits->{S} = 1;
        $card_suits->{H} = 2;
        $card_suits->{D} = 3;
        $card_suits->{C} = 4;

    return $card_suits->{$self->suit};
} ## --- end sub count_card_suit
#***********************************************************

package Hand;
use Data::Dumper;
sub new {
    my	$class = shift;
    my $self->{cards} = [@_];
    bless $self,$class;
    return $self;
} ## --- end sub new


sub status {

    $_[0]->{status} = $_[1] if defined $_[1];$_[0]->{status};
} ## --- end sub status
#
sub add_card {
    my $self = shift;
    my $card = shift;

    push @{$self->{cards}}, $card;

} ## --- end sub add_card

#return card with highest rating
sub higher_card {
    my $self = shift;
    my $return_result = shift;
    my @cards_ratings = map{$_->card_rating} @{$self->{cards}};

    my @sorted_cards_ratings = sort{$b <=> $a}@cards_ratings;

    #return sorted cards ratings if necessary else return 1
    return \@sorted_cards_ratings if ( defined $return_result );
    return 1;
} ## --- end sub higher_card

#return two cards with same value
sub one_pair {
    my $self = shift;
    my $return_result = shift;
    my %rating = ();
    my $max_pair_rating = 0;
    my $result = undef;
    my @cards = @{$self->{cards}};

    foreach my $card ( @cards ) {

        my $card_rating = $card->card_rating;
        push @{$rating{$card_rating}}, $card;
    }

    foreach my $r ( keys %rating  ) {

        if ( scalar @{ $rating{$r} } == 2 ){

            if ( $r > $max_pair_rating ){

                $max_pair_rating = $r;         
            }
        }
    }
    return 0 if ( $max_pair_rating == 0 );

    delete $rating{$max_pair_rating};
    push @$result, $max_pair_rating;
    push @$result, sort { $b <=> $a } keys %rating;

    #return ratings of cards pair and kikers in arr ref if needed result and pair exists
    return $result if ( defined $return_result );
    return 1;
} ## --- end sub one_pair

#return two different pairs
sub two_pairs {
    my $self = shift;
    my $return_result = shift;
    my %rating = ();
    my %pairs_only = ();
    my @result = ();

    my @cards = @{$self->{cards}};

    foreach my $card ( @cards ) {

        my $card_rating = $card->card_rating;
        push @{$rating{$card_rating}}, $card;
    }
    #$DB::single = 2;
    #print Dumper \%rating;
    foreach my $r ( keys %rating  ) {

        if ( scalar @{ $rating{$r} } == 2 ){

            $pairs_only{$r} = $rating{$r};
        }
    }

    my @pairs_ratings = sort { $b <=> $a }keys %pairs_only;
    #Cards didn't contain two pairs
    return 0 unless ( @pairs_ratings == 2 );

    foreach my $r ( @pairs_ratings ) {

        delete $rating{$r} if defined $rating{$r};
    }
    push @pairs_rating, sort { $b <=> $a }keys %rating;

    #return higher pair rating,smaller pair rating and kiker rating
    return \@pairs_rating if ( defined $return_result );
    #return only 1 if we don't need result only yes or no
    return 1 unless ( defined $return_result );

} ## --- end sub one_pair

#return three cards with same value
sub three_of_a_kind {
    my $self = shift;
    my $return_result = shift;
    my @cards = @{$self->{cards}};
    my %card_ratings = ();

    foreach my $card ( @cards ) {

        push @{ $card_ratings{$card->card_rating} }, $card;
    }
   #print Dumper \%card_ratings;

    my @cards_ratings = grep{ scalar @{$card_ratings{$_}} == 3 }keys %card_ratings;

    #return 0 if didn't exist three cards with same value
    return 0 if ( @cards_ratings == 0 );

    foreach my $r ( @cards_ratings ) {

        delete $card_ratings{$r} if exists $card_ratings{$r};
    }
    push @cards_ratings, sort { $b <=> $a }keys %card_ratings;
    #return ratings of three cards at first position and kikers if we need result and it's present
    return \@cards_ratings  if ( defined $return_result );
    #Do not return result;
    return 1;
} ## --- end sub three_of_a_kind

#Check if hand is a straight
sub straight {
    my $self = shift;
    my $return_result = shift;
    my $is_straight = 1;
    my @ratings = map{ $_->card_rating }@{$self->{cards}};
    #$DB::single = 2;
    my @sorted_ratings = sort { $a <=> $b } @ratings;

    #$DB::single = 2;
    for ( my $i = 1; $i < scalar @sorted_ratings; $i++ ) {

        unless ( $sorted_ratings[$i] - $sorted_ratings[$i-1] == 1 ){

            $is_straight = 0;
            last;
        }
    }
    #It isn't a straight
    return 0 if ( $is_straight == 0 );
    #It is a straight and we need result
    my @reversed_ratings = reverse @sorted_ratings;
    return \@reversed_ratings if ( defined $return_result && $is_straight == 1 );
    #It is a straight and we don't need result
    return $is_straight unless ( defined $return_result );
} ## --- end sub straight

sub flush {
    my $self = shift;
    my $return_result = shift;

    my @suits = map{ $_->count_card_suit }@{$self->{cards}};
    my %suits_count = ();

    foreach my $suit ( @suits ) {

        $suits_count{$suit}++;
    }
    #It isn't a flush
    return 0 unless ( scalar keys %suits_count == 1 );

    #if we don't need flush rating for compare
    return 1 if ( !defined $return_result );

    #return flush rating for compare
    my @ratings = map{$_->card_rating}@{$self->{cards}};
    my $ratings_summ = 0;
    foreach my $r ( @ratings ) {

        $ratings_summ += $r;
    }
    return $ratings_summ if ( defined $return_result );
} ## --- end sub flush

sub full_house {
    my $self = shift;
    my $return_result = shift;
    my %ratings = ();
    my @ratings = map{$_->card_rating} @{$self->{cards}};

    foreach my $r ( @ratings ) {

        $ratings{$r}++;
    }
    #$DB::single = 2;
    #There aren't two kinds of card
    return 0 unless (scalar keys %ratings == 2);

    my %reversed_ratings = reverse %ratings;

    #For example we have four cards with one rating and one card with another
    return 0 unless ( exists $reversed_ratings{2} && exists $reversed_ratings{3} );

    #return rating 3-cards, then rating 2-cards
    return [$reversed_ratings{3},$reversed_ratings{2}] if ( defined $return_result );

    #We don't need result just yes or no
    return 1;
} ## --- end sub full_house


sub four_of_a_kind {
    my $self = shift;
    my $return_result = shift;
    my @ratings = map{ $_->card_rating }@{$self->{cards}};
    my %ratings = ();

    foreach my $r ( @ratings ) {
        $ratings{$r}++;
    }

    #It can't be four of a kind
    return 0 if (scalar keys %ratings > 2);
    #$DB::single = 2;
    #
    my %reversed_ratings = reverse %ratings;
    #It isn't four of a kind
    #
    return 0 unless ( exists $reversed_ratings{4} );

    #return rating four of a kind and rationg of kiker if we need a result
    return [$reversed_ratings{4},$reversed_ratings{1}] if (defined $return_result );
    #We don't need a result but it's four of a kind
    return 1;
} ## --- end sub four_of_a_kind

sub straight_flush {
    my $self = shift;
    my $return_result = shift;

    if ( $self->straight && $self->flush ){

        my @ratings =sort { $b <=> $a } map{ $_->card_rating }@{$self->{cards}};

        #return higher rating of card
        return $ratings[0] if ( defined $return_result );

        #if we don't need result just yes
        return 1;

    }else{
        #Not straight flush
        return 0;
    }
} ## --- end sub straight_flush

sub royal_flush {
    my $self = shift;

    if ( $self->straight_flush && $self->straight_flush(1) == 14 ){

        return 1;

    }else{

        return 0;
    }
} ## --- end sub royal_flush
#***********************************************************
package PockerGame;
use Data::Dumper;

sub new {
    my $class = shift;
    my $self = {};

    bless $self,$class;
    return $self;
} ## --- end sub new
my $hand_size = 5;

sub process {
    my	( $self,$list )	= @_;
    my @results = ();
    foreach my $arr ( @$list ) {

        my @cards = ();
        foreach my $elem ( @$arr ) {

            #Create cards
            my $card = Card->new;
            my ($val,$suit) = (split (//,$elem));
            $card->val($val);
            $card->suit($suit);
            push @cards,$card;
        }

        #$DB::single = 2;
        my $left_hand = Hand->new;
        foreach my $i ( 0..$hand_size-1 ) {

            $left_hand->add_card( $cards[$i] );
        }

        my $right_hand = Hand->new;
        foreach my $i ( $hand_size.. 2*$hand_size -1 ) {

            $right_hand->add_card( $cards[$i] );
        }

        #print "1-------------------------------\n";
        #print Dumper \$left_hand;
        #print "2-------------------------------\n";
        #print Dumper \$right_hand;

        #Get left hand status(what rule in process)
        if ( $left_hand->royal_flush ){

            $left_hand->status(10);

        }elsif( $left_hand->straight_flush ){

            $left_hand->status(9);

        }elsif( $left_hand->four_of_a_kind ){

            $left_hand->status(8);

        }elsif( $left_hand->full_house ){

            $left_hand->status(7);

        }elsif( $left_hand->flush ){

            $left_hand->status(6);

        }elsif( $left_hand->straight ){

            $left_hand->status(5);

        }elsif( $left_hand->three_of_a_kind ){

            $left_hand->status(4);

        }elsif( $left_hand->two_pairs ){

            $left_hand->status(3);

        }elsif( $left_hand->one_pair ){

            $left_hand->status(2);

        }elsif( $left_hand->higher_card ){

            $left_hand->status(1);
        }

        #Get right hand status(what rule in process)
        if ( $right_hand->royal_flush ){

            $right_hand->status(10);

        }elsif( $right_hand->straight_flush ){

            $right_hand->status(9);

        }elsif( $right_hand->four_of_a_kind ){

            $right_hand->status(8);

        }elsif( $right_hand->full_house ){

            $right_hand->status(7);

        }elsif( $right_hand->flush ){

            $right_hand->status(6);

        }elsif( $right_hand->straight ){

            $right_hand->status(5);

        }elsif( $right_hand->three_of_a_kind ){

            $right_hand->status(4);

        }elsif( $right_hand->two_pairs ){

            $right_hand->status(3);

        }elsif( $right_hand->one_pair ){

            $right_hand->status(2);

        }elsif( $right_hand->higher_card ){

            $right_hand->status(1);
        }
        # $DB::single = 2;
        if ( $left_hand->status > $right_hand->status ){

            push @results,"left";

        }elsif( $left_hand->status < $right_hand->status ){

            push @results,"right";

        }else{

            compare_hands( $left_hand,$right_hand,\@results );
        }
    }
    return \@results;
} ## --- end sub process


sub compare_hands {
    my	( $left_hand,$right_hand,$result )	= @_;

    #Compare rating of single card
    if( $left_hand->status == 1 ){

        my $left_ratings = $left_hand->higher_card(1);
        my $right_ratings = $right_hand->higher_card(1);

        for ( my $i = 0;$i <= $#{$left_ratings};$i++ ) {

            if ( $left_ratings->[$i] > $right_ratings->[$i] ){

                push @$result, "left";
                last;

            }elsif ( $left_ratings->[$i] < $right_ratings->[$i] ){

                push @$result, "right";
                last;

            }else{

                push @$result,"none" if ($i == $#{$left_ratings});
            }
        }
    #Compare ratings of one pair
    }elsif( $left_hand->status == 2 ){

        my $left_ratings = $left_hand->one_pair(1);
        my $right_ratings = $right_hand->one_pair(1);

       for ( my $i = 0;$i <= $#{$left_ratings};$i++ ) {

            if ( $left_ratings->[$i] > $right_ratings->[$i] ){

                push @$result, "left";
                last;

            }elsif ( $left_ratings->[$i] < $right_ratings->[$i] ){

                push @$result, "right";
                last;

            }else{

                push @$result,"none" if ($i == $#{$left_ratings});
            }
        }
    #Compare raitings of two pairs
    }elsif( $left_hand->status == 3 ){

        my $left_ratings = $left_hand->two_pairs(1);
        my $right_ratings = $right_hand->two_pairs(1);

        for ( my $i = 0;$i <= $#{$left_ratings};$i++ ) {

            if ( $left_ratings->[$i] > $right_ratings->[$i] ){

                push @$result, "left";
                last;

            }elsif ( $left_ratings->[$i] < $right_ratings->[$i] ){

                push @$result, "right";
                last;

            }else{

                push @$result,"none" if ($i == $#{$left_ratings});
            }
        }
    #Compare ratings of three of a kind
    }elsif( $left_hand->status == 4 ){

        my $left_ratings = $left_hand->three_of_a_kind(1);
        my $right_ratings = $right_hand->three_of_a_kind(1);

        for ( my $i = 0;$i <= $#{$left_ratings};$i++ ) {

            if ( $left_ratings->[$i] > $right_ratings->[$i] ){

                push @$result, "left";
                last;

            }elsif ( $left_ratings->[$i] < $right_ratings->[$i] ){

                push @$result, "right";
                last;

            }else{

                push @$result,"none" if ($i == $#{$left_ratings});
            }
        }
    #Compare straight ratings
    }elsif( $left_hand->status == 5 ){

        my $left_ratings = $left_hand->straight(1);
        my $right_ratings = $right_hand->straight(1);

        for ( my $i = 0;$i <= $#{$left_ratings};$i++ ) {

            if ( $left_ratings->[$i] > $right_ratings->[$i] ){

                push @$result, "left";
                last;

            }elsif ( $left_ratings->[$i] < $right_ratings->[$i] ){

                push @$result, "right";
                last;

            }else{

                push @$result,"none" if ($i == $#{$left_ratings});
            }
        }
    #Compare flush ratings
    }elsif( $left_hand->status == 6 ){

        my $left_hand_flush_rating = $left_hand->flush(1);
        my $right_hand_flush_rating = $right_hand->flush(1);

        if ( $left_hand_flush_rating > $right_hand_flush_rating ){

            push @$result,"left";

        }elsif( $left_hand_flush_rating < $right_hand_flush_rating ){

            push @$result, "right";

        }else{

            push @$result,"none";
        }
    #Compare full house ratings
    }elsif( $left_hand->status == 7 ){

        my $left_fh_three_cards_ratings = $left_hand->full_house(1);
        my $right_fh_three_cards_ratings = $right_hand->full_house(1);

        #Compare three cards ratings
        if( $left_fh_three_cards_ratings->[0] > $right_fh_three_cards_ratings->[0] ){

            push @$result,"left";

        }elsif( $left_fh_three_cards_ratings->[0] < $right_fh_three_cards_ratings->[0] ){

            push @$result,"right";

        }else{
            #compare two cards rating
            if( $left_fh_three_cards_ratings->[1] > $right_fh_three_cards_ratings->[1] ){

                push @$result,"left";

            }elsif( $left_fh_three_cards_ratings->[1] < $right_fh_three_cards_ratings->[1] ){

                push @$result,"right";

            }else{

                push @$result,"none";
            }
        }
    #Compare four of a kind ratings
    }elsif( $left_hand->status == 8 ){

        my $left_four_ratings = $left_hand->four_of_a_kind(1);
        my $right_four_ratings = $right_hand->four_of_a_kind(1);

        #Compare four of a kind ratings
        if( $left_four_ratings->[0] > $right_four_ratings->[0] ){

            push @$result,"left";

        }elsif( $left_four_ratings->[0] < $right_four_ratings->[0] ){

            push @$result,"right";

        }else{
            #compare kikers
            if( $left_four_ratings->[1] > $right_four_ratings->[1] ){

                push @$result,"left";

            }elsif( $left_four_ratings->[1] < $right_four_ratings->[1] ){

                push @$result,"right";

            }else{

                push @$result,"none";
            }
        }
    #Compare straight flushes
    }elsif( $left_hand->status == 9 ){

        my $left_straight_flush_rating = $left_hand->straight_flush(1);
        my $right_straight_flush_rating = $right_hand->straight_flush(1);

        if( $left_straight_flush_rating > $right_straight_flush_rating ){

            push @$result, "left";

        }elsif( $left_straight_flush_rating < $right_straight_flush_rating ){

            push @$result,"right";

        }else{

            push @$result,"none";
        }
    #Compare royal flush ratings
    }elsif( $left_hand->status == 10 ){

        if ( $left_hand->royal_flush ){

            push @$result,"left";

        }elsif( $right_hand->royal_flush ){

            push @$result,"right";
        }else{

            push @$result,"none";
        }
    }
} ## --- end sub compare_hands



use strict;
use warnings;
use Data::Dumper;
use Benchmark;

open my $input, "/home/fanatic/Summoner/Codeeval-solutions/input.txt" || die "Can't open file: $!\n";
#open my $result, ">D:\\Perl\\output1.txt" || die "Can't open file: $!\n";

my @list = ();

	while(<$input>){
    	chomp;
	    push @list,[split /\s+/, $_];
	}
close $input;

my $game = PockerGame->new();
my $result = $game->process( \@list );


foreach my $r ( @$result ) {

    print "$r\n";
}
