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

    # Helper sets for a faster lookup
    RANKS_SET = RANKS.to_set.freeze
    SUITS_SET = SUITS.to_set.freeze

    attr_reader :rank, :suit

    # Initializes a new card.
    #
    # @param rank [String] The card's rank (2-9, T, J, Q, K, A) or the card's rank and suit (e.g. "9c")
    # @param suit [String, nil] The card's suit (c, d, h, s) or nil if the rank is a string with rank and suit
    def initialize(rank, suit = nil)
      rank, suit = rank.chars if suit.nil?
      validate_arguments rank, suit

      @rank = rank
      @suit = suit
    end

    # @return [String] The string with card's rank and suit (e.g. "As", "Td", "2c")
    def to_s
      @to_s ||= "#{rank}#{suit}"
    end

    # @return [Boolean] Whether two cards are identical
    def eql?(other)
      return false unless other.is_a?(Card)

      rank == other.rank && suit == other.suit
    end

    # @return [Integer] The card's hash value (required for using cards as hash keys)
    def hash
      to_s.hash
    end

    # @return [Boolean] Whether two cards are identical
    def ==(other)
      eql?(other)
    end

    # @return [String] The card's object string representation
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
