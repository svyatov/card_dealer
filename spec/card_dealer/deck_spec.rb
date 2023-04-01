# frozen_string_literal: true

RSpec.describe CardDealer::Deck do
  subject(:deck) { CardDealer::BuildDeck.standard52 }

  let(:another_deck) { CardDealer::BuildDeck.standard52 }

  describe "#shuffle" do
    it "shuffles the cards and returns the deck", aggregate_failures: true do
      cards_before_shuffle = deck.cards.dup
      expect(deck.shuffle).to be_a(described_class)
      expect(deck.cards).not_to eq(cards_before_shuffle)
      expect(deck.size).to eq(cards_before_shuffle.size)
    end

    it "can reproduce the same shuffle with a seed", aggregate_failures: true do
      expect { deck.shuffle }.to change(deck, :seed).from(nil).to(be_a(Integer))
      expect(deck).not_to eq(another_deck)
      another_deck.shuffle(deck.seed)
      expect(another_deck).to eq(deck)
    end

    it "does not change the seed if the deck is shuffled again", aggregate_failures: true do
      expect { deck.shuffle }.to change(deck, :seed).from(nil).to(be_a(Integer))
      expect { deck.shuffle }.not_to change(deck, :seed)
    end

    it "can reproduce multiple shuffles with a seed", aggregate_failures: true do
      first_shuffle_cards = deck.shuffle.cards.dup
      second_shuffle_cards = deck.shuffle.cards.dup
      expect(first_shuffle_cards).not_to eq(another_deck.cards)
      expect(second_shuffle_cards).not_to eq(another_deck.cards)
      expect(another_deck.shuffle(deck.seed).cards).to eq(first_shuffle_cards)
      expect(another_deck.shuffle(deck.seed).cards).to eq(second_shuffle_cards)
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

  describe "#deal" do
    let!(:cards) { deck.cards.dup }

    context "when dealing a single card without burning any cards" do
      it "returns the top card from the deck and removes it from the deck", aggregate_failures: true do
        top_card = cards[0]
        expect(deck.deal).to eq([top_card])
        expect(deck.cards).not_to include(top_card)
      end
    end

    context "when dealing multiple cards without burning any cards" do
      let(:dealt_cards) { deck.deal(2) }

      it "returns the specified number of cards from the top of the deck " \
         "and removes them from the deck", aggregate_failures: true do
        expect { dealt_cards }.to change { deck.cards.size }.by(-2)
        expect(dealt_cards).to eq([cards[0], cards[1]])
        expect(deck.cards).not_to include(dealt_cards)
        expect(deck.burned_cards).to be_empty
      end
    end

    context "when dealing a single card with burning cards" do
      let(:dealt_cards) { deck.deal(burn: 1) }

      it "burns the specified number of cards, returns the next card, " \
         "and removes the dealt and burned cards from the deck", aggregate_failures: true do
        expect { dealt_cards }.to change { deck.cards.size }.by(-2)
        expect(dealt_cards).to eq([cards[1]])
        expect(deck.cards).not_to include(dealt_cards)
        expect(deck.burned_cards).to include(cards[0])
      end
    end

    context "when dealing multiple cards with burning cards" do
      let(:dealt_cards) { deck.deal(2, burn: 1) }

      it "burns the specified number of cards, returns the specified number of cards after the burn, " \
         "and removes the dealt and burned cards from the deck", aggregate_failures: true do
        expect { dealt_cards }.to change { deck.cards.size }.by(-3)
        expect(dealt_cards).to eq([cards[1], cards[2]])
        expect(deck.cards).not_to include(dealt_cards)
        expect(deck.burned_cards).to include(cards[0])
      end
    end

    it "returns an empty array if the deck is empty", aggregate_failures: true do
      deck = described_class.new([])
      expect(deck.deal).to eq([])
      expect(deck.deal(5)).to eq([])
      expect(deck.deal(5, burn: 10)).to eq([])
    end

    it "accumulates the burned cards in the deck", aggregate_failures: true do
      expect do
        deck.deal(burn: 1)
        deck.deal(burn: 2)
      end.to change { deck.burned_cards.size }.by(3).and(change { deck.cards.size }.by(-5)) # 3 burned, 2 dealt
    end

    it "can burn cards without dealing any cards", aggregate_failures: true do
      expect do
        deck.deal(0, burn: 3)
        deck.deal(0, burn: 2)
      end.to change { deck.burned_cards.size }.by(5).and(change { deck.cards.size }.by(-5)) # 5 burned, 0 dealt
    end
  end

  describe "#to_binary_s" do
    it "encodes and returns the deck as a binary string" do
      expect(deck.to_binary_s).to eq(CardDealer::BinaryDeck.encode(deck))
    end
  end

  describe "#from_binary" do
    it "decodes and returns the deck from a binary string" do
      encoded_deck = CardDealer::BinaryDeck.encode(deck)
      expect(described_class.from_binary(encoded_deck)).to eq(deck)
    end
  end

  describe "#==" do
    it "returns false if the other object is not a deck" do
      expect(deck).not_to eq("not a deck")
    end

    it "returns true if the decks have the same cards in the same order" do
      expect(deck).to eq(CardDealer::BuildDeck.standard52)
    end

    it "returns false if the decks have different cards or cards are in different orders", aggregate_failures: true do
      expect(deck.shuffle).not_to eq(CardDealer::BuildDeck.standard52)
      expect(CardDealer::BuildDeck.standard52).not_to eq(CardDealer::BuildDeck.standard36)
    end
  end
end
