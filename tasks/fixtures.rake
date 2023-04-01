# frozen_string_literal: true

namespace :fixtures do
  desc "Generates deck fixtures for specs"
  task :generate do
    require "json"
    require_relative "../lib/card_dealer"

    # Less then 255 cards
    deck = CardDealer::BuildDeck.standard52.shuffle
    deck_partial = CardDealer::Deck.new(deck.cards.take(11)).shuffle
    deck_single_card = CardDealer::Deck.new([deck.cards.first])

    File.write("spec/fixtures/deck_standard52.json", JSON.pretty_generate(seed: deck.seed, cards: deck.to_a))
    File.write("spec/fixtures/deck_standard52.bin", CardDealer::BinaryDeck.encode(deck))
    File.write("spec/fixtures/deck_partial.json", JSON.pretty_generate(cards: deck_partial.to_a))
    File.write("spec/fixtures/deck_partial.bin", CardDealer::BinaryDeck.encode(deck_partial))
    File.write("spec/fixtures/deck_single_card.json", JSON.pretty_generate(cards: deck_single_card.to_a))
    File.write("spec/fixtures/deck_single_card.bin", CardDealer::BinaryDeck.encode(deck_single_card))

    # Between 255 and 65535 cards
    encodable_cards_limit_large = CardDealer::BinaryDeck::BIN_16_ENCODE_LIMIT
    max_encodable_decks_large = (encodable_cards_limit_large / deck.size).floor
    max_encodable_cards_large = (deck.cards * (max_encodable_decks_large + 1)).take(encodable_cards_limit_large)
    deck_large = CardDealer::Deck.new(max_encodable_cards_large).shuffle

    File.write("spec/fixtures/deck_large.json", JSON.pretty_generate(cards: deck_large.to_a))
    File.write("spec/fixtures/deck_large.bin", CardDealer::BinaryDeck.encode(deck_large))

    # More than 65535 cards
    deck_large_plus_one = CardDealer::Deck.new(max_encodable_cards_large + [deck.cards.sample]).shuffle
    deck_huge = CardDealer::Deck.new(max_encodable_cards_large * 2).shuffle

    File.write("spec/fixtures/deck_large_plus_one.json", JSON.pretty_generate(cards: deck_large_plus_one.to_a))
    File.write("spec/fixtures/deck_large_plus_one.bin", CardDealer::BinaryDeck.encode(deck_large_plus_one))
    File.write("spec/fixtures/deck_huge.json", JSON.pretty_generate(cards: deck_huge.to_a))
    File.write("spec/fixtures/deck_huge.bin", CardDealer::BinaryDeck.encode(deck_huge))
  end
end
