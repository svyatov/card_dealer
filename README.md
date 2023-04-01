# CardDealer
[![Gem Version](https://badge.fury.io/rb/card_dealer.svg)](https://badge.fury.io/rb/card_dealer)
[![Maintainability](https://api.codeclimate.com/v1/badges/a5266ef126fbbe754ff8/maintainability)](https://codeclimate.com/github/svyatov/card_dealer/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/a5266ef126fbbe754ff8/test_coverage)](https://codeclimate.com/github/svyatov/card_dealer/test_coverage)
[![MIT License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE.txt)

CardDealer is your go-to gem for creating, shuffling, and dealing decks of cards
with ease. Whether you're building a poker night app or a virtual bridge club,
CardDealer has got you covered. Enjoy customizable deck options, smooth
shuffling algorithms, and simple yet powerful deck manipulation tools that bring
the classic card game experience to life.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add card_dealer

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install card_dealer

## Usage

### Creating a standard 52-card deck

To create a standard 52-card deck, use the `CardDealer::BuildDeck.standard52` method:

```ruby
deck = CardDealer::BuildDeck.standard52
puts deck.cards
```

### Creating a standard 36-card deck

To create a standard 36-card deck, use the `CardDealer::BuildDeck.standard36` method:

```ruby
deck = CardDealer::BuildDeck.standard36
puts deck.cards
```

### Creating a custom deck of cards

To create a custom deck of cards, use the `CardDealer::BuildDeck.custom` method.
You can specify the number of decks, cards per suit, ranks, and suits:

```ruby
deck = CardDealer::BuildDeck.custom(
  decks: 2,
  cards_per_suit: 5,
  ranks: :highest,
  suits: %w[c d]
)
puts deck.cards
```

### Shuffling and dealing cards

The `CardDealer::Deck` class provides methods for shuffling and dealing cards:

```ruby
deck = CardDealer::BuildDeck.standard52
deck.shuffle
hand = deck.deal(5)
puts hand
```

You can also burn cards before dealing:

```ruby
deck = CardDealer::BuildDeck.standard52
deck.shuffle
hand = deck.deal(3, burn: 1)
puts hand
```

To burn cards without dealing, just pass `0` as the number of cards to deal:

```ruby
deck = CardDealer::BuildDeck.standard52
deck.shuffle
hand = deck.deal(0, burn: 1)
puts hand
```

Burned cards are stored within the deck and can be accessed via `burned_cards` method:

```ruby
deck = CardDealer::BuildDeck.standard52
deck.shuffle
deck.deal(0, burn: 10)
puts deck.burned_cards
```

### Encoding a deck of cards as a binary string

To encode a deck of cards as a binary string, use the `CardDealer::BinaryDeck.encode` method.
This is useful if you'd like to store a deck of cards in a database, cache, or a file:

```ruby
deck = CardDealer::BuildDeck.standard52
encoded_deck = CardDealer::BinaryDeck.encode(deck)
# - or -
encoded_deck = deck.to_binary_s
puts encoded_deck
```

### Decoding a binary string into a deck of cards

To decode a binary string into a deck of cards, use the `CardDealer::BinaryDeck.decode` method:

```ruby
encoded_deck = "\x02\xCDP" # binary string
decoded_deck = CardDealer::BinaryDeck.decode(encoded_deck)
# - or -
decoded_deck = CardDealer::Deck.from_binary(encoded_deck)
puts decoded_deck.cards
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/svyatov/card_dealer.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
