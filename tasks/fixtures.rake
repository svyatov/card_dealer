# frozen_string_literal: true

namespace :fixtures do
  desc "Generates deck fixtures for specs"
  task :generate do
    require "json"
    require_relative "../lib/card_dealer"

    deck = CardDealer::DeckBuilder.standard52.shuffle
    deck_partial = CardDealer::Deck.new(deck.cards.take(11)).shuffle
    deck_single_card = CardDealer::Deck.new([deck.cards.first])
    encodable_cards_limit = CardDealer::BinaryDeck::BIN_SCHEMA_XL_ENCODE_LIMIT
    max_encodable_decks = (encodable_cards_limit / deck.size).floor
    max_encodable_cards = (deck.cards * (max_encodable_decks + 1)).take(encodable_cards_limit)
    deck_max = CardDealer::Deck.new(max_encodable_cards).shuffle

    File.write("spec/fixtures/deck_standard52.json", JSON.pretty_generate(seed: deck.seed, cards: deck.to_a))
    File.write("spec/fixtures/deck_standard52.bin", CardDealer::BinaryDeck.encode(deck))
    File.write("spec/fixtures/deck_partial.json", JSON.pretty_generate(cards: deck_partial.to_a))
    File.write("spec/fixtures/deck_partial.bin", CardDealer::BinaryDeck.encode(deck_partial))
    File.write("spec/fixtures/deck_single_card.json", JSON.pretty_generate(cards: deck_single_card.to_a))
    File.write("spec/fixtures/deck_single_card.bin", CardDealer::BinaryDeck.encode(deck_single_card))
    File.write("spec/fixtures/deck_max.json", JSON.pretty_generate(cards: deck_max.to_a))
    File.write("spec/fixtures/deck_max.bin", CardDealer::BinaryDeck.encode(deck_max))
  end
end
