# frozen_string_literal: true

module CardDealer
  # The Card class represents a standard playing card with a rank and suit.
  #
  # A card has a rank (2-9, T, J, Q, K, A) and a suit (c, d, h, s).
  # The class provides methods to initialize a card, compare cards for equality,
  # and generate string representations of card instances.
  #
  # Example:
  #
  #   card1 = CardDealer::Card.new("A", "s")
  #   card2 = CardDealer::Card.new("K", "h")
  #   card3 = CardDealer::Card.new("As")
  #
  #   card1 == card3 # => true
  #   card1.to_s     # => "As"
  #   card2.inspect  # => '#<CardDealer::Card "Kh">'
  #
  class Card
    class InvalidRankError < Error; end
    class InvalidSuitError < Error; end

    CLUBS    = "c"
    DIAMONDS = "d"
    HEARTS   = "h"
    SPADES   = "s"

    # T = 10, J = Jack, Q = Queen, K = King, A = Ace
    RANKS = %w[2 3 4 5 6 7 8 9 T J Q K A].freeze
    SUITS = [CLUBS, DIAMONDS, HEARTS, SPADES].freeze
    RANK_MAP = RANKS.zip(0..12).to_h.freeze
    SUIT_MAP = SUITS.zip(0..3).to_h.freeze

    # @return [String] The rank of the card
    attr_reader :rank
    # @return [String] The suit of the card
    attr_reader :suit

    # Initializes a new card instance with the specified rank and suit.
    #
    # The method accepts either a combination of rank and suit as separate arguments
    # or a single string containing both rank and suit (e.g., "9c").
    #
    # @param rank [String] The card's rank (2-9, T, J, Q, K, A) or the card's combined rank and suit (e.g., "9c")
    # @param suit [String, nil] The card's suit (c, d, h, s). Omit if the rank parameter contains both rank and suit.
    #
    # @example Creating a card with separate rank and suit arguments
    #   card = CardDealer::Card.new("9", "c")
    #
    # @example Creating a card with a combined rank and suit string
    #   card = CardDealer::Card.new("9c")
    #
    def initialize(rank, suit = nil)
      rank, suit = rank.chars if suit.nil?
      validate_arguments rank, suit

      @rank = rank
      @suit = suit
    end

    # Returns the string representation of the card, combining its rank and suit (e.g., "As", "Td", "2c").
    #
    # @return [String] The card's combined rank and suit as a string.
    #
    # @example
    #   card = CardDealer::Card.new("A", "s")
    #   card.to_s #=> "As"
    #
    def to_s
      @to_s ||= "#{rank}#{suit}"
    end

    # Determines if two card instances are identical based on their rank and suit.
    #
    # This method compares the rank and suit of the current card instance with those
    # of another card instance. It returns true if both rank and suit are equal,
    # and false otherwise.
    #
    # @param other [Card] The card instance to compare with.
    #
    # @return [Boolean] True if the rank and suit of both card instances are equal, false otherwise.
    #
    # @example
    #   card1 = CardDealer::Card.new("A", "s")
    #   card2 = CardDealer::Card.new("A", "s")
    #   card1.eql?(card2) #=> true
    #
    def eql?(other)
      return false unless other.is_a?(Card)

      rank == other.rank && suit == other.suit
    end

    # Calculates a hash value for the card instance based on its string representation.
    #
    # This method computes a hash value for the card using the combined rank and suit string.
    # This hash value is required when using card instances as hash keys.
    #
    # @return [Integer] The hash value of the card instance.
    #
    # @example
    #   card = CardDealer::Card.new("A", "s")
    #   card_hash = card.hash
    #   cards_hash = { card => "Ace of Spades" }
    #
    def hash
      to_s.hash
    end

    # Compares two card instances for equality based on their rank and suit.
    #
    # This method utilizes the `eql?` method to compare the current card instance
    # with another card instance. It returns true if both rank and suit are equal,
    # and false otherwise.
    #
    # @param other [Card] The card instance to compare with.
    #
    # @return [Boolean] True if the rank and suit of both card instances are equal, false otherwise.
    #
    # @example
    #   card1 = CardDealer::Card.new("A", "s")
    #   card2 = CardDealer::Card.new("A", "s")
    #   card1 == card2 #=> true
    #
    def ==(other)
      eql?(other)
    end

    # Returns a string representation of the card instance's object state for debugging purposes.
    #
    # This method generates a human-readable string that includes the card's class and string representation.
    # It is useful for inspecting the object state when debugging.
    #
    # @return [String] A string representation of the card instance's object state.
    #
    # @example
    #   card = CardDealer::Card.new("A", "s")
    #   card.inspect #=> '#<CardDealer::Card "As">'
    #
    def inspect
      %(#<#{self.class} "#{self}">)
    end

    private

    # Validates the rank and suit arguments provided when initializing a card instance.
    #
    # @param rank [String] The card's rank (2-9, T, J, Q, K, A) to be validated.
    # @param suit [String] The card's suit (c, d, h, s) to be validated.
    #
    # @raise [InvalidRankError] If the rank is invalid.
    # @raise [InvalidSuitError] If the suit is invalid.
    #
    # @example
    #   # Valid rank and suit
    #   card = CardDealer::Card.new("A", "s")
    #
    #   # Invalid rank
    #   card = CardDealer::Card.new("X", "s") #=> raises InvalidRankError, "Invalid rank: X"
    #
    #   # Invalid suit
    #   card = CardDealer::Card.new("A", "x") #=> raises InvalidSuitError, "Invalid suit: x"
    #
    def validate_arguments(rank, suit)
      raise InvalidRankError, "Invalid rank: #{rank}" unless RANK_MAP.key?(rank)
      raise InvalidSuitError, "Invalid suit: #{suit}" unless SUIT_MAP.key?(suit)
    end
  end
end
