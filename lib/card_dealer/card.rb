# frozen_string_literal: true

module CardDealer
  class Card
    CLUBS = "c"
    DIAMONDS = "d"
    HEARTS = "h"
    SPADES = "s"

    RANKS = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze
    SUITS = [CLUBS, DIAMONDS, HEARTS, SPADES].freeze

    attr_reader :rank, :suit

    def initialize(rank, suit)
      @rank = rank
      @suit = suit
    end

    # @return [String] the card's rank and suit
    def to_s
      "#{rank}#{suit}"
    end
  end
end
