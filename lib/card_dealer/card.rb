# frozen_string_literal: true

module CardDealer
  class Card
    CLUBS    = "c"
    DIAMONDS = "d"
    HEARTS   = "h"
    SPADES   = "s"

    # T = 10, J = Jack, Q = Queen, K = King, A = Ace
    RANKS = %w[2 3 4 5 6 7 8 9 T J Q K A].freeze
    SUITS = [CLUBS, DIAMONDS, HEARTS, SPADES].freeze

    # For faster lookup
    RANKS_SET = RANKS.to_set.freeze
    SUITS_SET = SUITS.to_set.freeze

    attr_reader :rank, :suit

    # Initializes a new card.
    #
    # @param rank [String] the card's rank (2-9, T, J, Q, K, A)
    # @param suit [String] the card's suit (c, d, h, s)
    def initialize(rank, suit)
      validate_arguments rank, suit

      @rank = rank
      @suit = suit
    end

    # @return [String] the card's rank and suit
    def to_s
      "#{rank}#{suit}"
    end

    # @return [String] the card's object string representation
    def inspect
      %(#<CardDealer::Card "#{self}">)
    end

    private

    def validate_arguments(rank, suit)
      raise Error, "Invalid rank: #{rank}" unless RANKS_SET.include?(rank)
      raise Error, "Invalid suit: #{suit}" unless SUITS_SET.include?(suit)
    end
  end
end
