# frozen_string_literal: true

module CardDealer
  # The BinaryDeck class provides a way to efficiently store a deck of cards as binary data.
  # It can encode a deck of cards into a binary string and decode it back into a deck.
  # This class can handle encoding and decoding of decks with up to 4'294'967'295 cards.
  #
  # The binary format consists of an initial byte(s) representing the number of cards in the deck,
  # followed by a series of 6-bit card representations packed into bytes.
  #
  # An encoded deck with 52 or fewer cards takes up no more than 40 bytes.
  #
  class BinaryDeck
    class DeckTooLargeError < Error; end

    SUIT_MAP = Card::SUIT_MAP.transform_values { |value| value * 13 }
    RANK_MAP = Card::RANK_MAP

    # A hash mapping cards to their corresponding numbers
    CARD_NUMBER_MAP = SUIT_MAP.each_with_object({}) do |(suit, suit_number), hash|
      RANK_MAP.each do |rank, rank_number|
        hash[Card.new(rank, suit)] = suit_number + rank_number
      end
    end.freeze

    # A hash mapping cards to their corresponding binary strings
    CARD_BINARY_NUMBER_MAP = CARD_NUMBER_MAP.transform_values { |number| format "%06b", number }.freeze
    # A hash mapping binary strings to their corresponding cards
    REVERSE_CARD_BINARY_NUMBER_MAP = CARD_BINARY_NUMBER_MAP.invert

    # The binary format string for encoding/decoding decks with size <= 255
    BIN_TEMPLATE_8 = "CB*"
    # The binary format string for encoding/decoding decks with size > 255 and <= 65535
    BIN_TEMPLATE_16 = "SB*"
    # The binary format string for encoding/decoding decks with size > 65535
    BIN_TEMPLATE_32 = "LB*"

    # The maximum deck size supported by the BIN_TEMPLATE_8 format
    BIN_8_ENCODE_LIMIT = 255
    # The maximum encoded deck bytesize supported by the BIN_TEMPLATE_8 format
    BIN_8_DECODE_LIMIT = 193
    # The maximum deck size supported by the BIN_TEMPLATE_16 format
    BIN_16_ENCODE_LIMIT = 65_535
    # The maximum encoded deck bytesize supported by the BIN_TEMPLATE_16 format
    BIN_16_DECODE_LIMIT = 49_154
    # The maximum deck size supported by the BIN_TEMPLATE_32 format
    BIN_32_ENCODE_LIMIT = 4_294_967_295
    # The maximum encoded deck bytesize supported by the BIN_TEMPLATE_32 format
    BIN_32_DECODE_LIMIT = 3_221_225_472

    class << self
      # Encodes a deck of cards into a binary string using a suitable template.
      #
      # The method takes a Deck object, maps each card to its corresponding binary number,
      # and concatenates the binary numbers to create a single binary string. Then, it chooses
      # the appropriate binary encoding template based on the deck size and packs the deck size
      # and binary numbers into a single encoded binary string.
      #
      # @param deck [Deck] The deck of cards to encode.
      #
      # @return [String] The encoded binary string representing the deck of cards.
      #
      # @example
      #   deck = CardDealer::Deck.new([CardDealer::Card.new("As"), CardDealer::Card.new("Td")])
      #   encoded_deck = CardDealer::BinaryDeck.encode(deck)
      #   encoded_deck #=> "\x02\xCDP" (binary string)
      #
      def encode(deck)
        template = encoding_template_for deck.size
        binary_numbers = deck.cards.map { |card| CARD_BINARY_NUMBER_MAP.fetch(card) }.join
        [deck.size, binary_numbers].pack(template)
      end

      # Decodes a binary string into a deck of cards using a suitable template.
      #
      # The method takes an encoded binary string, and based on its size, selects the
      # appropriate decoding template. It unpacks the binary string into a deck size
      # and binary numbers. Then, it scans the binary numbers, takes the required number
      # of cards based on the deck size, and maps each binary number back to its
      # corresponding card. Finally, it returns a new Deck object containing the decoded cards.
      #
      # @param encoded_deck [String] The encoded binary string to decode.
      #
      # @return [Deck] The decoded deck of cards.
      #
      # @example
      #   encoded_deck = "\x02\xCDP" # (binary string)
      #   decoded_deck = CardDealer::BinaryDeck.decode(encoded_deck)
      #   decoded_deck.cards #=> [#<CardDealer::Card "As">, #<CardDealer::Card "Td">]
      #
      def decode(encoded_deck)
        template = decoding_template_for encoded_deck.bytesize
        deck_size, binary_numbers = encoded_deck.unpack(template)
        cards = binary_numbers.scan(/.{6}/).take(deck_size).map do |binary_number|
          REVERSE_CARD_BINARY_NUMBER_MAP.fetch(binary_number)
        end

        Deck.new cards
      end

      private

      # Determines the appropriate encoding template based on the deck size.
      #
      # The method checks the deck size and returns the corresponding binary template
      # for encoding the deck. If the deck size is too large to be supported, it raises
      # a DeckTooLargeError.
      #
      # @param deck_size [Integer] The number of cards in the deck to be encoded.
      #
      # @return [String] The appropriate encoding template based on the deck size.
      #
      # @raise [DeckTooLargeError] If the deck size is too large to be supported.
      #
      # @example
      #   encoding_template_for(52) #=> "CB*"
      #   encoding_template_for(520) #=> "SB*"
      #   encoding_template_for(5_000_000_000) #=> raises DeckTooLargeError
      #
      def encoding_template_for(deck_size)
        return BIN_TEMPLATE_8  if deck_size <= BIN_8_ENCODE_LIMIT
        return BIN_TEMPLATE_16 if deck_size <= BIN_16_ENCODE_LIMIT
        return BIN_TEMPLATE_32 if deck_size <= BIN_32_ENCODE_LIMIT

        raise DeckTooLargeError, "Deck size #{deck_size} is too large to encode!"
      end

      # Determines the appropriate decoding template based on the size of the encoded deck.
      #
      # The method checks the encoded deck size and returns the corresponding binary template
      # for decoding the deck. If the encoded deck size is too large to be supported, it raises
      # a DeckTooLargeError.
      #
      # @param bytesize [Integer] The size of the encoded deck to be decoded.
      #
      # @return [String] The appropriate decoding template based on the encoded deck size.
      #
      # @raise [DeckTooLargeError] If the encoded deck size is too large to be supported.
      #
      # @example
      #   decoding_template_for(40) #=> "CB*"
      #   decoding_template_for(392) #=> "SB*"
      #   decoding_template_for(4_000_000_000) #=> raises DeckTooLargeError
      #
      def decoding_template_for(bytesize)
        return BIN_TEMPLATE_8  if bytesize <= BIN_8_DECODE_LIMIT
        return BIN_TEMPLATE_16 if bytesize <= BIN_16_DECODE_LIMIT
        return BIN_TEMPLATE_32 if bytesize <= BIN_32_DECODE_LIMIT

        raise DeckTooLargeError, "Encoded deck size #{bytesize} is too large to decode!"
      end
    end
  end
end
