# frozen_string_literal: true

RSpec.describe CardDealer::Deck do
  context "when no arguments are passed" do
    subject(:deck) { described_class.new }

    it "has 52 cards by default" do
      expect(deck.cards.size).to eq(52)
    end

    it "has 4 suits by default" do
      expect(deck.cards.map(&:suit).uniq.size).to eq(4)
    end

    it "has 13 ranks by default" do
      expect(deck.cards.map(&:rank).uniq.size).to eq(13)
    end
  end

  context "when arguments are passed" do
    subject(:custom_deck) do
      described_class.new(decks:, cards_per_suit:, ranks:, suits:)
    end

    let(:decks) { 1 }
    let(:cards_per_suit) { 13 }
    let(:ranks) { :highest }
    let(:suits) { :all }

    context "when decks is 2" do
      let(:decks) { 2 }

      it "has 104 cards" do
        expect(custom_deck.cards.size).to eq(104)
      end

      it "has 4 suits by default" do
        expect(custom_deck.cards.map(&:suit).uniq.size).to eq(4)
      end

      it "has 13 ranks by default" do
        expect(custom_deck.cards.map(&:rank).uniq.size).to eq(13)
      end
    end

    context "when cards_per_suit is 9" do
      let(:cards_per_suit) { 9 }

      it "has 36 cards" do
        expect(custom_deck.cards.size).to eq(36)
      end

      it "has 4 suits by default" do
        expect(custom_deck.cards.map(&:suit).uniq.size).to eq(4)
      end

      it "has 9 ranks with face cards" do
        expect(custom_deck.cards.map(&:rank).uniq).to eq(%w[6 7 8 9 T J Q K A])
      end
    end

    context "when ranks is :lowest and cards_per_suit is 9" do
      let(:ranks) { :lowest }
      let(:cards_per_suit) { 9 }

      it "has 36 cards" do
        expect(custom_deck.cards.size).to eq(36)
      end

      it "has 4 suits by default" do
        expect(custom_deck.cards.map(&:suit).uniq.size).to eq(4)
      end

      it "has 9 ranks with pip cards" do
        expect(custom_deck.cards.map(&:rank).uniq).to eq(%w[2 3 4 5 6 7 8 9 T])
      end
    end

    context "when ranks is an array" do
      let(:ranks) { %w[2 4 6 8 T Q A] }

      it "has 28 cards" do
        expect(custom_deck.cards.size).to eq(28)
      end

      it "has 4 suits by default" do
        expect(custom_deck.cards.map(&:suit).uniq.size).to eq(4)
      end

      it "has 7 ranks" do
        expect(custom_deck.cards.map(&:rank).uniq).to eq(ranks)
      end
    end

    context "when suits is Hearts" do
      let(:suits) { [CardDealer::Card::HEARTS] }

      it "has 13 cards" do
        expect(custom_deck.cards.size).to eq(13)
      end

      it "has 1 suit" do
        expect(custom_deck.cards.map(&:suit).uniq).to eq(suits)
      end

      it "has 13 ranks" do
        expect(custom_deck.cards.map(&:rank).uniq.size).to eq(13)
      end
    end

    context "when suits is Hearts and Spades" do
      let(:suits) { [CardDealer::Card::HEARTS, CardDealer::Card::SPADES] }

      it "has 26 cards" do
        expect(custom_deck.cards.size).to eq(26)
      end

      it "has 2 suits" do
        expect(custom_deck.cards.map(&:suit).uniq).to eq(suits)
      end

      it "has 13 ranks" do
        expect(custom_deck.cards.map(&:rank).uniq.size).to eq(13)
      end
    end

    context "when ranks is invalid" do
      let(:ranks) { :invalid }

      it "raises an error" do
        expect { custom_deck }.to raise_error(CardDealer::Error)
      end
    end

    context "when suits is invalid" do
      let(:suits) { :invalid }

      it "raises an error" do
        expect { custom_deck }.to raise_error(CardDealer::Error)
      end
    end
  end
end
