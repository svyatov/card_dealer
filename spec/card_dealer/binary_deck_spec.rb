# frozen_string_literal: true

require "card_dealer"
require "card_dealer/binary_deck"

RSpec.describe CardDealer::BinaryDeck do
  let(:deck) { CardDealer::BuildDeck.standard52.shuffle }

  describe ".encode" do
    let(:deck_partial) { CardDealer::Deck.new(deck.cards.take(11)).shuffle }
    let(:deck_large) { CardDealer::BuildDeck.standard52(decks: 1000).shuffle }
    let(:deck_huge) { CardDealer::BuildDeck.standard52(decks: 10_000).shuffle }
    let(:deck_out_of_range) { instance_double(CardDealer::Deck, size: 2**32) }

    it "encodes a partial deck into a binary string", :aggregate_failures do
      encoded_deck = described_class.encode(deck_partial)
      expect(encoded_deck).to be_a(String)
      expect(encoded_deck.bytesize).to eq(10)
    end

    it "encodes a standard deck into a binary string", :aggregate_failures do
      encoded_deck = described_class.encode(deck)
      expect(encoded_deck).to be_a(String)
      expect(encoded_deck.encoding).to eq(Encoding::BINARY)
      expect(encoded_deck.bytesize).to eq(40)
    end

    it "encodes a large deck into a binary string", :aggregate_failures do
      encoded_deck = described_class.encode(deck_large)
      expect(encoded_deck).to be_a(String)
      expect(encoded_deck.bytesize).to eq(39_002)
    end

    it "encodes a huge deck into a binary string", :aggregate_failures do
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

    it "decodes a binary string back into a deck", :aggregate_failures do
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

    {
      "a missing header" => "".b,
      "a missing payload" => [1].pack("C"),
      "an incomplete card payload" => [2, 0].pack("CC"),
      "excess payload bytes" => [1, 0, 0].pack("CCC"),
      "a truncated 16-bit deck at the header-width boundary" => [256].pack("S") + ("\0" * 191),
      "a truncated 32-bit deck at the header-width boundary" => [65_536].pack("L") + ("\0" * 49_150)
    }.each do |description, payload|
      it "rejects #{description}" do
        expect { described_class.decode(payload) }.to raise_error(described_class::InvalidEncodingError)
      end
    end

    it "decodes an empty deck" do
      expect(described_class.decode("\0").cards).to eq([])
    end

    [255, 256, 65_535, 65_536].each do |size|
      it "preserves all #{size} cards at a header-width boundary" do
        original_deck = CardDealer::Deck.new(Array.new(size) { CardDealer::Card.new("2c") })
        decoded_deck = described_class.decode(described_class.encode(original_deck))

        expect(decoded_deck.to_a).to eq(Array.new(size, "2c"))
      end
    end
  end

  it "encodes and decodes a deck without losing data", :aggregate_failures do
    encoded_deck = described_class.encode(deck)
    decoded_deck = described_class.decode(encoded_deck)
    expect(decoded_deck).to be_a(CardDealer::Deck)
    expect(decoded_deck.size).to eq(deck.size)
    expect(decoded_deck.cards).to eq(deck.cards)
  end
end
