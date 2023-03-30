# frozen_string_literal: true

RSpec.describe CardDealer::Deck do
  subject(:deck) { CardDealer::DeckBuilder.standard52 }

  let(:another_deck) { CardDealer::DeckBuilder.standard52 }

  describe "#shuffle" do
    it "shuffles the cards and returns the deck", aggregate_failures: true do
      cards_before_shuffle = deck.to_a
      expect(deck.shuffle).to be_a(described_class)
      expect(deck.to_a).not_to eq(cards_before_shuffle)
      expect(deck.cards.size).to eq(cards_before_shuffle.size)
    end

    it "can reproduce the same shuffle with a seed", aggregate_failures: true do
      deck.shuffle
      expect(deck.to_a).not_to eq(another_deck.to_a)
      another_deck.shuffle(deck.seed)
      expect(another_deck.to_a).to eq(deck.to_a)
    end
  end

  describe "#to_a" do
    it "returns the array of cards as strings" do
      expect(deck.to_a).to eq(deck.cards.map(&:to_s))
    end
  end

  describe "#to_s" do
    it "returns the cards as strings" do
      expect(deck.to_s).to eq(deck.cards.map(&:to_s).to_s)
    end
  end
end
