# frozen_string_literal: true

require "set"

module CardDealer
  class Error < StandardError; end
end

require_relative "card_dealer/version"
require_relative "card_dealer/card"
require_relative "card_dealer/deck"
require_relative "card_dealer/build_deck"
require_relative "card_dealer/binary_deck"
