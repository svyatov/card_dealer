# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/2.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

The public API covered by Semantic Versioning is the public methods of
`CardDealer::Card`, `CardDealer::Deck`, `CardDealer::BuildDeck`, and
`CardDealer::BinaryDeck`, the binary format `BinaryDeck` produces, and the
minimum Ruby version. Private methods and the RBS signatures under `sig/` are
outside it. While the version is below 1.0.0, an incompatible change bumps
MINOR and every other change bumps PATCH. A public item is deprecated with a
runtime warning naming its replacement for at least one release before it is
removed.

## [Unreleased]

### Changed

- **Breaking:** Ruby 3.3 or newer is required. Ruby 3.1 and 3.2 reached end of life and are no longer tested.
- Development dependencies updated to their current releases (RuboCop 1.90, RSpec 3.13, Steep 2.1, rbs 4.2)
- CI runs on Ruby 3.3, 3.4, and 4.0

## [0.2.0] - 2023-04-01

### Added

- `BinaryDeck` class to convert decks to binary format and back
  (to save space when storing decks in a database, for example)
- `BuildDeck` class to build decks
- `Card` instances are now safe to use as hash keys
- `Card#eql?`, `Card#hash` and `Card#==` methods to compare cards and safely use them as hash keys
- `Card#<=>` method to make cards sortable
- `Deck#size` method to get the number of cards in the deck
- `Deck#deal` method to deal cards from the deck
- `Deck#to_binary_s` helper method to convert the deck to a binary string
- `Deck#from_binary` helper method to convert the binary string to a deck
- `Deck#==` method to compare decks for equality
- Lots of documentation
- [Steep](https://github.com/soutaro/steep) gem to check type correctness

### Changed

- **Breaking:** Deck building is extracted from the `Deck` class to the `BuildDeck` class.
  `Deck#new` now takes an array of cards instead of a hash of options.
  Call `BuildDeck.standard52`, `BuildDeck.standard36`, or `BuildDeck.custom` to build a deck.
- It's now possible to initialize a card with a string, e.g. `Card.new('9c')`

### Removed

- **Breaking:** `Deck#reset`. It was removed without a deprecation notice in 0.1.0,
  so no release warned before the removal. Build a new deck with `BuildDeck` where
  `reset` was called.

### Fixed

- All the type declarations are now correct

## [0.1.0] - 2023-03-26

Initial release!

### Added

- `Card` class
- `Deck` class
- Ability to create a decks of various sizes, ranks, and suits
- Ability to shuffle a deck
- Ability to reset a deck

[unreleased]: https://github.com/svyatov/card_dealer/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/svyatov/card_dealer/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/svyatov/card_dealer/releases/tag/v0.1.0
