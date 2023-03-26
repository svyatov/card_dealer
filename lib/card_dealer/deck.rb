# frozen_string_literal: true

module CardDealer
  class Deck
    attr_reader :cards

    # @param decks [Integer] the number of decks to use
    # @param cards_per_suit [Integer] the number of cards per suit to use
    # @param ranks [Array<String>, :highest, :lowest] the ranks to use
    #   @option :highest will use the highest cards_per_suit ranks (A, K, Q, J, T, ...)
    #   :lowest will use the lowest cards_per_suit ranks (2, 3, 4, 5, 6, ...)
    #   array will use the specified ranks (e.g. %w[2 4 6 8 T])
    # @param suits [Array<String>, :all] the suits to use
    #   :all will use all suits (♠, ♣, ♥, ♦)
    #   array will use the specified suits (e.g. %w[♠ ♣])
    # @raise [Error] if ranks or suits are invalid
    def initialize(decks: 1, cards_per_suit: 13, ranks: :highest, suits: :all)
      @cards = []

      suits = build_suits suits
      ranks = build_ranks ranks, cards_per_suit

      decks.times do
        suits.each do |suit|
          ranks.each do |rank|
            @cards << Card.new(rank, suit)
          end
        end
      end
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
