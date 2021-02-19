class Card
  include Comparable

  RANKS = %w(2 3 4 5 6 7 8 9 10 Jack Queen King Ace)

  attr_reader :rank, :suit, :rank_index

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
    @rank_index = RANKS.find_index(rank.to_s)
  end

  def <=>(other)
    self.rank_index <=> other.rank_index
  end

  def to_s
    "#{rank} of #{suit}"
  end
end

class Deck
  RANKS = ((2..10).to_a + %w(Jack Queen King Ace)).freeze
  SUITS = %w(Hearts Clubs Diamonds Spades).freeze

  attr_accessor :cards

  def initialize
    @cards
    reset_deck
  end

  def draw
    if cards.empty?
      reset_deck
    end
    drawn_card = cards.sample
    cards.delete(drawn_card)
  end

  def reset_deck
    self.cards = SUITS.product(RANKS).map do |card|
                    Card.new(card[1], card[0])
                  end
    cards.shuffle!
  end
end

deck = Deck.new
drawn = []
52.times { drawn << deck.draw }
drawn.count { |card| card.rank == 5 } == 4
drawn.count { |card| card.suit == 'Hearts' } == 13

drawn2 = []
52.times { drawn2 << deck.draw }
p drawn != drawn2 # Almost always.