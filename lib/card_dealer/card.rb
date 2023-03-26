# frozen_string_literal: true

module CardDealer
  class Card
    CLUBS = "c"
    DIAMONDS = "d"
    HEARTS = "h"
    SPADES = "s"

    RANKS = %w[2 3 4 5 6 7 8 9 T J Q K A].freeze
    SUITS = [CLUBS, DIAMONDS, HEARTS, SPADES].freeze

    RANKS_SET = RANKS.to_set.freeze
    SUITS_SET = SUITS.to_set.freeze

    attr_reader :rank, :suit

    def initialize(rank, suit)
      validate_arguments rank, suit

      @rank = rank
      @suit = suit
    end

    # @return [String] the card's rank and suit
    def to_s
      "#{rank}#{suit}"
    end

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
