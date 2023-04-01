## [Unreleased]

### BREAKING CHANGES

- Deck building in extracted from the `Deck` class to the `DeckBuilder` class:
  - `Deck#new` now takes an array of cards instead of a hash of options
  - `Deck#reset` removed

### Added

- `BinaryDeck` class to convert decks to binary format and back
  (to save space when storing decks in a database, for example)
- `DeckBuilder` class to build decks
- `Card` instances are now safe to use as hash keys
- `Card#eql?`, `Card#hash` and `Card#==` methods to compare cards and safely use them as hash keys
- `Deck#size` method to get the number of cards in the deck
- `Deck#deal` method to deal cards from the deck
- Lots of documentation
- [Steep](https://github.com/soutaro/steep) gem to check types correctness

### Changed

- It's possible to initialize a card with a string now, e.g. `Card.new('9c')`

### Fixed

- All the type declarations are now correct

## [0.1.0] - 2023-03-26

Initial release!

### Added

- `Card` class
- `Deck` class
- Ability to create a decks of various size, ranks and suits
- Ability to shuffle a deck
- Ability to reset a deck
