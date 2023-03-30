# frozen_string_literal: true

module CardDealer
  class Deck
    attr_reader :cards, :seed

    # Initializes a new deck.
    #
    # @param cards [Array<Card>] The array of cards to use in the deck (see {DeckBuilder})
    def initialize(cards)
      @cards = cards
    end

    # Shuffles the deck using the Fisher-Yates algorithm.
    #
    # @param seed [Integer] The seed to use for shuffling
    # @return [Deck]
    def shuffle(seed = Random.new_seed)
      @seed = seed
      @cards.shuffle! random: Random.new(seed)
      self
    end

    # @return [Integer] The number of cards in the deck
    def size
      cards.size
    end

    # @return [Array<String>] The array of cards in the deck as strings (see {Card#to_s})
    def to_a
      cards.map(&:to_s)
    end

    # @return [String] The cards in the deck as a single string
    def to_s
      to_a.to_s
    end
  end
end
