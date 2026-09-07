# CardDealer

CardDealer builds, shuffles, and deals decks of playing cards for Ruby card game applications.

[![gem](https://img.shields.io/gem/v/card_dealer)](https://rubygems.org/gems/card_dealer)
[![CI](https://github.com/svyatov/card_dealer/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/svyatov/card_dealer/actions/workflows/main.yml)

- **Three deck shapes.** Builds standard 52-card and 36-card decks, and custom decks from any ranks, suits, and number of decks.
- **Replayable shuffles.** Shuffles with Fisher-Yates from a seed you can pass in or read back from the deck.
- **40 bytes for 52 cards.** Encodes a deck to a binary string for a database, a cache, or a file.
- **No runtime dependencies.** Requires Ruby 3.3 or newer and nothing else.

Add it to your Gemfile:

```bash
bundle add card_dealer
```

Then build a deck, shuffle it, and deal a hand:

```ruby
require "card_dealer"

deck = CardDealer::BuildDeck.standard52.shuffle(42)
deck.deal(5).map(&:to_s) # => ["8d", "4s", "Ts", "Ac", "6s"]
deck.size                # => 47
```

A card prints as its rank (2 to 9, T, J, Q, K, A) followed by its suit (c, d, h, s).

## Usage

### Building a standard 52-card deck

To build a 52-card deck, call `CardDealer::BuildDeck.standard52`:

```ruby
deck = CardDealer::BuildDeck.standard52
deck.size          # => 52
deck.to_a.first(3) # => ["2c", "3c", "4c"]
```

### Building a standard 36-card deck

To build a 36-card deck, call `CardDealer::BuildDeck.standard36`:

```ruby
deck = CardDealer::BuildDeck.standard36
deck.size          # => 36
deck.to_a.first(3) # => ["6c", "7c", "8c"]
```

### Building a custom deck

To build a custom deck, call `CardDealer::BuildDeck.custom`. `ranks` takes `:highest`, `:lowest`, or an array such as `%w[2 4 6 8 T]`. `suits` takes `:all` or an array such as `%w[d h]`:

```ruby
deck = CardDealer::BuildDeck.custom(
  decks: 2,
  cards_per_suit: 5,
  ranks: :highest,
  suits: %w[c d]
)
deck.size          # => 20
deck.to_a.first(6) # => ["Tc", "Jc", "Qc", "Kc", "Ac", "Td"]
```

### Shuffling and dealing cards

`CardDealer::Deck#shuffle` takes an optional seed. Without one, it generates a seed and stores it in `seed`, so you can replay the shuffle later:

```ruby
deck = CardDealer::BuildDeck.standard52
deck.shuffle
seed = deck.seed    # keep this to replay the shuffle
hand = deck.deal(5) # => five CardDealer::Card objects
deck.size           # => 47
```

To burn cards before dealing, pass `burn:`:

```ruby
deck = CardDealer::BuildDeck.standard52.shuffle(42)
hand = deck.deal(3, burn: 1)
hand.map(&:to_s)              # => ["4s", "Ts", "Ac"]
deck.burned_cards.map(&:to_s) # => ["8d"]
```

To burn cards without dealing, deal `0` cards:

```ruby
deck = CardDealer::BuildDeck.standard52.shuffle(42)
deck.deal(0, burn: 10)
deck.burned_cards.size # => 10
deck.size              # => 42
```

### Encoding a deck as a binary string

To encode a deck, call `CardDealer::BinaryDeck.encode` or `Deck#to_binary_s`. Each card takes 6 bits, after a 1, 2, or 4 byte header carrying the card count:

```ruby
deck = CardDealer::Deck.new([CardDealer::Card.new("As"), CardDealer::Card.new("Td")])
encoded = CardDealer::BinaryDeck.encode(deck)
# - or -
encoded = deck.to_binary_s
encoded # => "\x02\xCDP"
```

### Decoding a binary string into a deck

To decode a binary string, call `CardDealer::BinaryDeck.decode` or `Deck.from_binary`:

```ruby
encoded = "\x02\xCDP"
deck = CardDealer::BinaryDeck.decode(encoded)
# - or -
deck = CardDealer::Deck.from_binary(encoded)
deck.to_a # => ["As", "Td"]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Run `bundle exec rake` to run the type checker, the linter, and the tests. Run `bin/console` for an interactive prompt.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `lib/card_dealer/version.rb`. Add the release to `CHANGELOG.md`. Push a tag such as `v0.3.0`, which cuts the release.

## Contributing

Read [CONTRIBUTING.md](CONTRIBUTING.md) for setup, tests, and how to open a pull request. To report a vulnerability, follow [SECURITY.md](SECURITY.md).

## Help and status

Ask questions and report bugs in [GitHub issues](https://github.com/svyatov/card_dealer/issues).

CardDealer is actively maintained by one person. Releases happen when there is something to release.

## License

CardDealer is available under the [MIT License](LICENSE.txt). Releases are listed in [CHANGELOG.md](CHANGELOG.md).
