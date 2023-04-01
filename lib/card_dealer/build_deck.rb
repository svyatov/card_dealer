# frozen_string_literal: true

module CardDealer
  # The BuildDeck class is responsible for creating a deck of cards with various configurations.
  #
  # It allows specifying the number of decks, cards per suit, ranks, and suits. It also provides
  # methods for creating standard 52-card and 36-card decks. The resulting deck can be used with
  # the {Deck} class for shuffling and other operations.
  #
  class BuildDeck
    class InvalidRanksError < Error; end
    class InvalidSuitsError < Error; end

    class << self
      # Builds a new deck with the specified configuration.
      #
      # @param decks [Integer] The number of decks to use.
      # @param cards_per_suit [Integer] The number of cards per suit to use.
      # @param ranks [Array<String>, :highest, :lowest] The ranks to use.
      #   - :highest will use the highest cards_per_suit ranks (A, K, Q, J, T, ...).
      #   - :lowest will use the lowest cards_per_suit ranks (2, 3, 4, 5, 6, ...).
      #   - Array will use the specified ranks (e.g., %w[2 4 6 8 T]).
      # @param suits [Array<String>, :all] The suits to use.
      #   - :all will use all suits (c, d, h, s).
      #   - Array will use the specified suits (e.g., %w[d h]).
      #
      # @return [Deck] A new deck with the specified configuration of cards.
      #
      # @raise [InvalidRanksError] If ranks are invalid.
      # @raise [InvalidSuitsError] If suits are invalid.
      #
      def custom(decks: 1, cards_per_suit: 13, ranks: :highest, suits: :all)
        ranks = build_ranks ranks, cards_per_suit
        suits = build_suits suits
        build_deck decks, ranks, suits
      end

      # Builds a standard 52-card deck.
      #
      # @param decks [Integer] The number of decks to use.
      #
      # @return [Deck] A new deck with the standard 52-card configuration.
      #
      def standard52(decks: 1)
        custom decks:
      end

      # Builds a standard 36-card deck.
      #
      # @param decks [Integer] The number of decks to use.
      #
      # @return [Deck] A new deck with the standard 36-card configuration.
      #
      def standard36(decks: 1)
        custom decks:, cards_per_suit: 9
      end

      private

      # Builds the ranks for the deck based on the provided configuration.
      #
      # @param ranks [:highest, :lowest, Array<String>] The ranks configuration.
      # @param cards_per_suit [Integer] The number of cards per suit.
      #
      # @return [Array<String>] The resulting ranks for the deck.
      #
      # @raise [InvalidRanksError] If the ranks configuration is invalid.
      #
      def build_ranks(ranks, cards_per_suit)
        case ranks
        when :highest
          Card::RANKS.last(cards_per_suit)
        when :lowest
          Card::RANKS.first(cards_per_suit)
        when Array
          ranks
        else
          raise InvalidRanksError, "Invalid ranks: #{ranks}"
        end
      end

      # Builds the suits for the deck based on the provided configuration.
      #
      # @param suits [:all, Array<String>] The suits configuration.
      #
      # @return [Array<String>] The resulting suits for the deck.
      #
      # @raise [InvalidSuitsError] If the suits configuration is invalid.
      #
      def build_suits(suits)
        case suits
        when :all
          Card::SUITS
        when Array
          suits
        else
          raise InvalidSuitsError, "Invalid suits: #{suits}"
        end
      end

      # Builds the deck using the specified configuration of decks, ranks, and suits.
      #
      # @param decks [Integer] The number of decks to use.
      # @param ranks [Array<String>] The ranks to use in the deck.
      # @param suits [Array<String>] The suits to use in the deck.
      #
      # @return [Deck] A new deck object with the specified configuration.
      #
      def build_deck(decks, ranks, suits)
        cards = []

        decks.times do
          suits.each do |suit|
            ranks.each do |rank|
              cards << Card.new(rank, suit)
            end
          end
        end

        Deck.new cards
      end
    end
  end
end
