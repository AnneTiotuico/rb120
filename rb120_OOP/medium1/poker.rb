class Card
  include Comparable

  attr_reader :rank, :suit

  VALUES = {'Ace' => 14,
            'King' => 13,
            'Queen' => 12,
            'Jack' => 11 }

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def <=>(object)
    determine_value <=> object.determine_value
  end

  def determine_value
    case rank
    when Integer
      rank
    when String
      VALUES[rank]
    end
  end

  def to_s
    "#{rank} of #{suit}"
  end
end

class Deck
  RANKS = ((2..10).to_a + %w(Jack Queen King Ace)).freeze
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze

  def initialize
    create
  end

  def start
    cards = []
    SUITS.each do |suit|
      RANKS.each do |rank|
        cards << Card.new(rank, suit)
      end
    end
    cards
  end

  def shuffle
    @cards.shuffle!
  end

  def create
    @cards = start
    shuffle
  end

  def draw
    create if @cards.empty?
    @cards.pop
  end
end

class PokerHand
  def initialize(deck)
    @hand = []
    5.times do
      @hand << deck.draw
    end
    @value_hands = @hand.map { |card| card.determine_value }
  end

  def print
    puts @hand
  end

  def evaluate
    case
    when royal_flush?     then 'Royal flush'
    when straight_flush?  then 'Straight flush'
    when four_of_a_kind?  then 'Four of a kind'
    when full_house?      then 'Full house'
    when flush?           then 'Flush'
    when straight?        then 'Straight'
    when three_of_a_kind? then 'Three of a kind'
    when two_pair?        then 'Two pair'
    when pair?            then 'Pair'
    else                       'High card'
    end
  end

  private

  def royal_flush?
    #Five cards of the same suit in sequence (if those five are A, K, Q, J, 10; it is a Royal Flush)
    @hand.all? { |card| card.suit == @hand[0].suit } &&
    ((['Ace', 'King', 'Queen', 'Jack', 10] - @hand.map { |card| card.rank }).empty?)
  end

  def straight_flush?
    #Five cards of the same suit in sequence (if those five are A, K, Q, J, 10; it is a Royal Flush)
    value_hands = @value_hands.sort
    @hand.all? { |card| card.suit == @hand[0].suit } &&
    (value_hands.uniq == value_hands) &&
    (value_hands.first..value_hands.last).to_a - value_hands == []
  end

  def four_of_a_kind?
    # Four cards of the same rank and any one other card
    @value_hands.any? { |card| @value_hands.count(card) == 4 }
  end

  def full_house?
    # Three cards of one rank and two of another

    @value_hands.any? { |card| @value_hands.count(card) == 3 } &&
    @value_hands.any? { |card| @value_hands.count(card) == 2 }
  end

  def flush?
     # Five cards of the same suit
    @hand.all? { |card| card.suit == @hand[0].suit }
  end

  def straight?
    # Five cards in sequence (for example, 4, 5, 6, 7, 8)
    value_hands = @value_hands.sort
    (value_hands.uniq == value_hands) &&
    (value_hands.first..value_hands.last).to_a - value_hands == []
  end

  def three_of_a_kind?
    # Three cards of the same rank
    @value_hands.any? { |card| @value_hands.count(card) == 3 }
  end

  def two_pair?
    # Two cards of one rank and two cards of another
    @value_hands.uniq.length == 3
  end

  def pair?
    # Two cards of the same rank
    @value_hands.any? { |card| @value_hands.count(card) == 2 }
  end
end

hand = PokerHand.new(Deck.new)
hand.print
puts hand.evaluate

# Danger danger danger: monkey
# patching for testing purposes.
class Array
  alias_method :draw, :pop
end

# Test that we can identify each PokerHand type.
hand = PokerHand.new([
  Card.new(10,      'Hearts'),
  Card.new('Ace',   'Hearts'),
  Card.new('Queen', 'Hearts'),
  Card.new('King',  'Hearts'),
  Card.new('Jack',  'Hearts')
])
puts hand.evaluate == 'Royal flush'

hand = PokerHand.new([
  Card.new(8,       'Clubs'),
  Card.new(9,       'Clubs'),
  Card.new('Queen', 'Clubs'),
  Card.new(10,      'Clubs'),
  Card.new('Jack',  'Clubs')
])
puts hand.evaluate == 'Straight flush'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Four of a kind'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Full house'

hand = PokerHand.new([
  Card.new(10, 'Hearts'),
  Card.new('Ace', 'Hearts'),
  Card.new(2, 'Hearts'),
  Card.new('King', 'Hearts'),
  Card.new(3, 'Hearts')
])
puts hand.evaluate == 'Flush'

hand = PokerHand.new([
  Card.new(8,      'Clubs'),
  Card.new(9,      'Diamonds'),
  Card.new(10,     'Clubs'),
  Card.new(7,      'Hearts'),
  Card.new('Jack', 'Clubs')
])
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new('Queen', 'Clubs'),
  Card.new('King',  'Diamonds'),
  Card.new(10,      'Clubs'),
  Card.new('Ace',   'Hearts'),
  Card.new('Jack',  'Clubs')
])
puts hand.evaluate == 'Straight'

hand = PokerHand.new([
  Card.new(3, 'Hearts'),
  Card.new(3, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(3, 'Spades'),
  Card.new(6, 'Diamonds')
])
puts hand.evaluate == 'Three of a kind'

hand = PokerHand.new([
  Card.new(9, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(8, 'Spades'),
  Card.new(5, 'Hearts')
])
puts hand.evaluate == 'Two pair'

hand = PokerHand.new([
  Card.new(2, 'Hearts'),
  Card.new(9, 'Clubs'),
  Card.new(5, 'Diamonds'),
  Card.new(9, 'Spades'),
  Card.new(3, 'Diamonds')
])
puts hand.evaluate == 'Pair'

hand = PokerHand.new([
  Card.new(2,      'Hearts'),
  Card.new('King', 'Clubs'),
  Card.new(5,      'Diamonds'),
  Card.new(9,      'Spades'),
  Card.new(3,      'Diamonds')
])
puts hand.evaluate == 'High card'