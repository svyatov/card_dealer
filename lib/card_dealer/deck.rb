# frozen_string_literal: true

module CardDealer
  class Deck
    attr_reader :cards, :seed

    # Initializes a new deck.
    #
    # @param decks [Integer] the number of decks to use
    # @param cards_per_suit [Integer] the number of cards per suit to use
    # @param ranks [Array<String>, :highest, :lowest] the ranks to use
    #   @option :highest will use the highest cards_per_suit ranks (A, K, Q, J, T, ...)
    #   :lowest will use the lowest cards_per_suit ranks (2, 3, 4, 5, 6, ...)
    #   array will use the specified ranks (e.g. %w[2 4 6 8 T])
    # @param suits [Array<String>, :all] the suits to use
    #   :all will use all suits (c, d, h, s)
    #   array will use the specified suits (e.g. %w[d h])
    # @raise [Error] if ranks or suits are invalid
    def initialize(decks: 1, cards_per_suit: 13, ranks: :highest, suits: :all)
      @decks = decks
      @ranks = build_ranks ranks, cards_per_suit
      @suits = build_suits suits
      reset
    end

    # Resets the deck to its original state.
    #
    # @return [Deck]
    def reset
      @cards = []

      @decks.times do
        @suits.each do |suit|
          @ranks.each do |rank|
            @cards << Card.new(rank, suit)
          end
        end
      end

      self
    end

    # Shuffles the deck using the Fisher-Yates algorithm.
    #
    # @param seed [Integer] the seed to use for shuffling
    # @return [Deck]
    def shuffle(seed = Random.new_seed)
      @seed = seed
      @cards.shuffle! random: Random.new(seed)
      self
    end

    # @return [Array<String>] the array of cards in the deck as strings
    def to_a
      cards.map(&:to_s)
    end

    # @return [String] the cards in the deck as a string
    def to_s
      to_a.to_s
    end

    private

    def build_suits(suits)
      case suits
      when :all
        Card::SUITS
      when Array
        suits
      else
        raise Error, "Invalid suits: #{suits}"
      end
    end

    def build_ranks(ranks, cards_per_suit)
      case ranks
      when :highest
        Card::RANKS.last(cards_per_suit)
      when :lowest
        Card::RANKS.first(cards_per_suit)
      when Array
        ranks
      else
        raise Error, "Invalid ranks: #{ranks}"
      end
    end
  end
end
