## [Unreleased]

## [0.2.0] - 2023-04-01

### BREAKING CHANGES

- Deck building is extracted from the `Deck` class to the `BuildDeck` class:
  - `Deck#new` now takes an array of cards instead of a hash of options
  - `Deck#reset` removed

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

- It's now possible to initialize a card with a string, e.g. `Card.new('9c')`

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
