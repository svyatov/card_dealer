# frozen_string_literal: true

module CardDealer
  # The BinaryDeck class provides a way to efficiently store a deck of cards as binary data.
  # It can encode a deck of cards into a binary string and decode it back into a deck.
  # This class can handle encoding and decoding of decks with up to 65535 cards.
  #
  # The binary format consists of an initial byte (or two bytes for decks larger than 255 cards)
  # representing the number of cards in the deck, followed by a series of 6-bit card
  # representations packed into bytes.
  #
  # An encoded deck with 52 or fewer cards takes up no more than 40 bytes.
  class BinaryDeck
    class DeckTooLargeError < Error; end

    SUIT_MAP = Card::SUITS.zip([0, 13, 26, 39]).to_h.freeze
    RANK_MAP = Card::RANKS.zip(0..12).to_h.freeze
    # A hash mapping cards to their corresponding numbers
    CARD_NUMBER_MAP = Card::SUITS.product(Card::RANKS).each_with_object({}) do |(suit, rank), hash|
      hash[Card.new(rank, suit)] = SUIT_MAP[suit] + RANK_MAP[rank]
    end
    # A hash mapping cards to their corresponding binary strings
    CARD_BINARY_NUMBER_MAP = CARD_NUMBER_MAP.transform_values { |number| format "%06b", number }
    # A hash mapping binary strings to their corresponding cards
    REVERSE_CARD_BINARY_NUMBER_MAP = CARD_BINARY_NUMBER_MAP.invert

    # The binary format string for encoding/decoding decks with size <= 255
    BIN_SCHEMA = "CB*"
    # The binary format string for encoding/decoding decks with size > 255
    BIN_SCHEMA_XL = "SB*"

    # The maximum deck size supported by the BIN_SCHEMA format
    BIN_SCHEMA_ENCODE_LIMIT = 255
    # The maximum encoded deck bytesize supported by the BIN_SCHEMA format
    BIN_SCHEMA_DECODE_LIMIT = 193
    # The maximum deck size supported by the BIN_SCHEMA_XL format
    BIN_SCHEMA_XL_ENCODE_LIMIT = 65_535
    # The maximum encoded deck bytesize supported by the BIN_SCHEMA_XL format
    BIN_SCHEMA_XL_DECODE_LIMIT = 49_154

    class << self
      # Encodes a deck of cards into a binary string.
      #
      # @param deck [Deck] The deck of cards to encode
      # @return [String] The encoded binary string
      def encode(deck)
        raise DeckTooLargeError if deck.size > BIN_SCHEMA_XL_ENCODE_LIMIT

        schema = deck.size > BIN_SCHEMA_ENCODE_LIMIT ? BIN_SCHEMA_XL : BIN_SCHEMA
        binary_numbers = deck.cards.map { |card| CARD_BINARY_NUMBER_MAP[card] }.join
        [deck.size, binary_numbers].pack(schema)
      end

      # Decodes a binary string into a deck of cards.
      #
      # @param encoded_deck [String] The encoded binary string to decode
      # @return [Deck] The decoded deck of cards
      def decode(encoded_deck)
        raise DeckTooLargeError if encoded_deck.bytesize > BIN_SCHEMA_XL_DECODE_LIMIT

        schema = encoded_deck.bytesize > BIN_SCHEMA_DECODE_LIMIT ? BIN_SCHEMA_XL : BIN_SCHEMA
        deck_size, binary_numbers = encoded_deck.unpack(schema)
        cards = binary_numbers.scan(/.{6}/).take(deck_size).map do |binary_number|
          REVERSE_CARD_BINARY_NUMBER_MAP[binary_number]
        end

        Deck.new cards
      end
    end
  end
end
