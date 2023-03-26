# frozen_string_literal: true

module CardDealer
  class Deck
    attr_reader :cards

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
