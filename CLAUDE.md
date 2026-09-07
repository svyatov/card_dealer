# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

CardDealer is a Ruby gem for creating, shuffling, and dealing decks of playing cards. It supports standard 52-card and 36-card decks, custom deck configurations, and binary serialization for storage.

## Commands

```bash
# Install dependencies
bin/setup

# Run all checks (default task: steep + rubocop + rspec)
bundle exec rake

# Run tests only
bundle exec rake spec

# Run a single test file
bundle exec rspec spec/card_dealer/card_spec.rb

# Run a specific test by line number
bundle exec rspec spec/card_dealer/deck_spec.rb:42

# Run linter
bundle exec rake rubocop

# Run type checker
bundle exec rake steep

# Interactive console
bin/console
```

## Architecture

The gem has four main classes under the `CardDealer` module:

- **Card** (`lib/card_dealer/card.rb`) - Represents a single playing card with rank (2-A, where T=10) and suit (c/d/h/s). Cards are comparable and can be used as hash keys.

- **Deck** (`lib/card_dealer/deck.rb`) - A collection of cards supporting shuffle (Fisher-Yates with optional seed), deal, and burn operations. Tracks burned cards separately.

- **BuildDeck** (`lib/card_dealer/build_deck.rb`) - Factory class with class methods for creating decks:
  - `standard52` / `standard36` for common configurations
  - `custom` for specifying decks count, cards per suit, ranks (`:highest`, `:lowest`, or array), and suits

- **BinaryDeck** (`lib/card_dealer/binary_deck.rb`) - Encodes/decodes decks to/from binary strings using 6-bit card representations. Supports decks up to 4 billion cards with three template sizes (8/16/32-bit headers).

## Type Definitions

RBS type signatures are in `sig/`. The project uses Steep for type checking with lenient diagnostics configured in `Steepfile`.

## Requirements

- Ruby >= 3.3.0
