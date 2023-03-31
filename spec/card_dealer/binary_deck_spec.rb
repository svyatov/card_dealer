# frozen_string_literal: true

require "card_dealer"
require "card_dealer/binary_deck"

RSpec.describe CardDealer::BinaryDeck do
  let(:deck) { CardDealer::DeckBuilder.standard52.shuffle }

  describe ".encode" do
    let(:deck_partial) { CardDealer::Deck.new(deck.cards.take(11)).shuffle }
    let(:deck_large) { CardDealer::DeckBuilder.standard52(decks: 1000).shuffle }
    let(:deck_huge) { CardDealer::DeckBuilder.standard52(decks: 10_000).shuffle }
    let(:deck_out_of_range) { instance_double(CardDealer::Deck, size: 2**32) }

    it "encodes a partial deck into a binary string", aggregate_failures: true do
      encoded_deck = described_class.encode(deck_partial)
      expect(encoded_deck).to be_a(String)
      expect(encoded_deck.bytesize).to eq(10)
    end

    it "encodes a standard deck into a binary string", aggregate_failures: true do
      encoded_deck = described_class.encode(deck)
      expect(encoded_deck).to be_a(String)
      expect(encoded_deck.encoding).to eq(Encoding::BINARY)
      expect(encoded_deck.bytesize).to eq(40)
    end

    it "encodes a large deck into a binary string", aggregate_failures: true do
      encoded_deck = described_class.encode(deck_large)
      expect(encoded_deck).to be_a(String)
      expect(encoded_deck.bytesize).to eq(39_002)
    end

    it "encodes a huge deck into a binary string", aggregate_failures: true do
      encoded_deck = described_class.encode(deck_huge)
      expect(encoded_deck).to be_a(String)
      expect(encoded_deck.bytesize).to eq(390_004)
    end

    it "raises an error if the deck is too large" do
      expect { described_class.encode(deck_out_of_range) }.to raise_error(CardDealer::BinaryDeck::DeckTooLargeError)
    end
  end

  describe ".decode" do
    let(:stored_decks) do
      %w[
        deck_standard52
        deck_partial
        deck_single_card
        deck_large
        deck_large_plus_one
        deck_huge
      ]
    end
    let(:deck_out_of_range) { instance_double(String, bytesize: described_class::BIN_32_DECODE_LIMIT + 1) }

    it "decodes a binary string back into a deck", aggregate_failures: true do # rubocop:disable RSpec/ExampleLength
      stored_decks.each do |stored_deck|
        encoded_deck = File.read("spec/fixtures/#{stored_deck}.bin")
        original_cards = JSON.parse(File.read("spec/fixtures/#{stored_deck}.json"))["cards"]
        original_deck = CardDealer::Deck.new(original_cards.map { |card| CardDealer::Card.new(card) })
        decoded_deck = described_class.decode(encoded_deck)
        expect(decoded_deck).to be_a(CardDealer::Deck)
        expect(decoded_deck.size).to eq(original_deck.size)
        expect(decoded_deck.cards).to eq(original_deck.cards)
      end
    end

    it "raises an error if the deck is too large" do
      expect { described_class.decode(deck_out_of_range) }.to raise_error(CardDealer::BinaryDeck::DeckTooLargeError)
    end
  end

  it "encodes and decodes a deck without losing data", aggregate_failures: true do
    encoded_deck = described_class.encode(deck)
    decoded_deck = described_class.decode(encoded_deck)
    expect(decoded_deck).to be_a(CardDealer::Deck)
    expect(decoded_deck.size).to eq(deck.size)
    expect(decoded_deck.cards).to eq(deck.cards)
  end
end
