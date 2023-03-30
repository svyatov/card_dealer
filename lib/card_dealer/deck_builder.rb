# frozen_string_literal: true

module CardDealer
  class DeckBuilder
    class << self
      # Builds a new deck.
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
      def call(decks: 1, cards_per_suit: 13, ranks: :highest, suits: :all)
        ranks = build_ranks ranks, cards_per_suit
        suits = build_suits suits
        build_deck decks, ranks, suits
      end

      def standard52(decks: 1)
        call decks:
      end

      def standard36(decks: 1)
        call decks:, cards_per_suit: 9
      end

      private

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

      # @return [Deck]
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
