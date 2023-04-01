# frozen_string_literal: true

module CardDealer
  # The Deck class represents a collection of cards.
  #
  # It supports operations like shuffling, getting the size of the deck, and converting
  # the deck to an array or string. The deck can be initialized with an array of {Card}
  # objects, which can be created using the {DeckBuilder} class.
  #
  class Deck
    # @return [Array<Card>] The array of cards in the deck.
    attr_reader :cards
    # @return [Integer, nil] The seed used for shuffling the deck.
    attr_reader :seed
    # @return [Array<Card>] The array of cards that have been burned.
    attr_reader :burned_cards

    # Initializes a new deck with the specified cards.
    #
    # @param cards [Array<Card>] The array of cards to use in the deck (see {DeckBuilder}).
    #
    def initialize(cards)
      @cards = cards
      @burned_cards = []
    end

    # Shuffles the deck using the Fisher-Yates algorithm.
    #
    # @param seed [Integer] The seed to use for shuffling. If not provided, a new seed is generated.
    #
    # @return [Deck] The shuffled deck.
    #
    def shuffle(seed = Random.new_seed)
      @seed ||= seed
      @cards.shuffle! random: Random.new(@seed.to_i)
      self
    end

    # Deals a specified number of cards from the top of the deck, optionally burning cards before the deal.
    #
    # The method removes the specified number of cards from the top of the deck and returns them.
    # If the burn parameter is specified, it will remove (burn) the indicated number of cards
    # from the top of the deck before dealing.
    #
    # @param num [Integer] The number of cards to deal (default: 1).
    # @param burn [Integer] The number of cards to burn before dealing (default: 0).
    #
    # @return [Array<Card>] The dealt cards.
    #
    # @example
    #   deck = CardDealer::Deck.new([CardDealer::Card.new("As"), CardDealer::Card.new("Td")])
    #   dealt_cards = deck.deal(burn: 1)
    #   dealt_cards #=> [#<CardDealer::Card "Td">]
    #   deck.burned_cards #=> [CardDealer::Card.new("As")]
    #
    def deal(num = 1, burn: 0)
      @burned_cards += cards.shift(burn) if burn.positive?
      cards.shift(num)
    end

    # Returns the number of cards in the deck.
    #
    # @return [Integer] The number of cards in the deck.
    #
    def size
      cards.size
    end

    # Returns an array of cards as strings in the deck.
    #
    # @return [Array<String>] The array of cards in the deck as strings (see {Card#to_s})
    #
    def to_a
      cards.map(&:to_s)
    end

    # Returns the cards in the deck as a single string.
    #
    # @return [String] The cards in the deck as a single string.
    #
    def to_s
      to_a.to_s
    end
  end
end
