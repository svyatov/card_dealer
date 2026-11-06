# Next feature for CardDealer

## Subject

Identify the next obvious missing feature in this Ruby gem. Rank one feature, as requested.

The best feature candidate is atomic round-robin dealing to multiple hands. There is no evidence that any feature is mandatory.

Repair the confirmed binary-decoder truncation defect before adding features. The validation section records its reproduction.

Follow-up: commit `4376fae` implements the length check and documents `CardDealer::BinaryDeck::InvalidEncodingError`. The findings below describe the checkout examined before that repair.

### Grounding

- README.md:3 defines the purpose: "CardDealer builds, shuffles, and deals decks of playing cards for Ruby card game applications."
- `lib/card_dealer/deck.rb:56-58` implements one contiguous deal with optional burns. Multi-hand distribution requires caller loops.
- `spec/card_dealer/deck_spec.rb:97-102` intentionally permits empty results. Exact dealing must use an explicit new contract.
- `lib/card_dealer/binary_deck.rb:68-98` stores remaining card order. It omits the seed and burned cards.
- `CHANGELOG.md:54-56` records removal of `Deck#reset` and recommends rebuilding with `BuildDeck`.
- Recent commits `83513ab`, `bb3d2ce`, and `afa9a3d` concern dependency maintenance. They supply no feature-demand evidence.
- GitHub returned no open issues for `svyatov/card_dealer` on 2026-11-06. No glossary, ADRs, or tracker guide were found.

### Method

One read-only explorer supplied grounding. Four generation tasks covered all six ideation frames. Their results merged into 18 distinct candidates and three combinations.

An independent verifier checked all 21 candidates against the source and arguments. No verifier verdict was overruled.

Utility is inferred from the API. Source evidence establishes capability gaps, not consumer demand. Sizes include implementation, signatures, documentation, and meaningful tests.

## Ranked ideas

### 1. Atomic round-robin dealing to multiple hands

Distribute one card to each hand per round, returning ordinary arrays of cards. Check the entire request before removing cards.

If capacity is insufficient, raise a documented error and leave the deck unchanged. Preserve the permissive behavior of `deal`.

**Basis, direct:** `lib/card_dealer/deck.rb:56` defines `def deal(num = 1, burn: 0)`. Line 57 executes `@burned_cards += cards.shift(burn) if burn.positive?`. Line 58 executes `cards.shift(num)`. This returns a single contiguous group and performs no capacity preflight. `spec/card_dealer/deck_spec.rb:97-102` explicitly tests empty-array results for empty decks.

**Why it matters:** Games that distribute alternating cards need a caller loop. Games that require complete hands also need a capacity check.

Combining those operations gives one bounded dealing capability. It fits the stated purpose without introducing game rules, players, or hand classes.

**Size:** M. The algorithm is small, but public error semantics, signatures, compatibility, and examples need care.

**Proposed shape, subject to design:**

```ruby
hands = deck.deal_hands(players: 3, cards_each: 2)
# From an unshuffled standard deck:
# [[2c, 5c], [3c, 6c], [4c, 7c]] as Card objects
```

The smallest scope has positive player counts, nonnegative card counts, capacity validation, and no burns. Names and zero-count behavior require design review.

Atomic means capacity validation before mutation. It does not imply thread safety or protection against external mutation through `cards`.

**Main objection:** A short Ruby loop already performs distribution. The feature earns its maintenance cost only if consumers need the shared ordering and failure contract.

**Take it further**

```text
$grill-with-docs Atomic round-robin dealing to multiple hands in CardDealer.

Basis, direct: lib/card_dealer/deck.rb:56 defines `def deal(num = 1, burn: 0)`. Line 57 executes `@burned_cards += cards.shift(burn) if burn.positive?`. Line 58 executes `cards.shift(num)`. This returns a single contiguous group and performs no capacity preflight. spec/card_dealer/deck_spec.rb:97-102 explicitly tests empty-array results for empty decks.

Why it matters: Games that distribute alternating cards need a caller loop. Games that require complete hands also need a capacity check. Combining those operations gives one bounded dealing capability. It fits the stated purpose without introducing game rules, players, or hand classes.

Consider a separate API such as deal_hands(players:, cards_each:), returning arrays of Card objects. Distribute one card per player per round. Validate the complete request before mutation. Insufficient capacity must leave the deck unchanged. Preserve existing deal behavior. Start without burns.

Challenge whether a documented loop is sufficient before accepting a permanent API. There is no open-issue demand evidence. Resolve names, zero counts, error types, size limits, and compatibility before implementation.
```

## Cut

These cuts rank one next feature. They do not declare every alternative useless. IDs refer to the merged candidate list.

| ID | Idea | Basis | Reason |
| --- | --- | --- | --- |
| I1 | Round-robin dealing alone | direct: `deck.rb:58`, `cards.shift(num)`, returns one group. | Duplicate of the stronger ranked combination, I20. |
| I2 | Exact dealing alone | direct: `deck.rb:57-58` burns before dealing, without preflight. | Combined into I20; a standalone strict API remains a separate design choice. |
| I3 | Peek | direct: `deck.rb:12`, `attr_reader :cards`, already exposes inspection. | Cost over value: `deck.cards.first(n)` already expresses the operation. |
| I4 | Enumerable iteration | direct: `deck.rb:93`, `cards.map(&:to_s)`, defines string-valued `to_a`. | Cost over value: collection methods exist through `cards`; iteration would need a careful `to_a` contract. |
| I5 | Full state snapshots | direct: `binary_deck.rb:70-71` encodes cards and size; `:98`, `Deck.new cards`, reconstructs fresh state. | Cost over value: no demonstrated consumer needs seed and burned cards restored. |
| I6 | Independent deck copies | direct: `deck.rb:23`, `@cards = cards`; `:35` and `:58` mutate the collection. | Cost over value for the next feature: branching demand is unproven and card mutability needs a defined policy. |
| I7 | Exclude known cards by multiplicity | direct: `build_deck.rb:112-115` repeats decks; `card.rb:91` compares rank and suit values. | Cost over value: useful for simulations, but the scenario is not evidenced. |
| I8 | Validated binary decoding | direct: `binary_deck.rb:94-95` uses `scan(/.{6}/).take(deck_size)` and map `fetch`; a truncated payload silently decoded one of two declared cards. | Classify as a confirmed repair, not a speculative feature. Prioritize the repair before the ranked feature. |
| I9 | Ordered import from card notation | direct: `README.md:103` constructs individual cards inside `Deck.new`. | Cost over value: mapping card strings through `Card.new` is already small. |
| I10 | Generic arbitrary-card decks | reasoned: dealing requires ordered removal, not ranks or suits; separating those concerns enables more games. | Cost over value: expands the domain and conflicts with assumptions in card encoding. |
| I11 | Caller-supplied random generator | direct: `deck.rb:35`, `Random.new(@seed.to_i)`, constructs the generator internally. | Cost over value: coordinating random streams is unproven demand and complicates replay semantics. |
| I12 | Replayable operation transcript | direct: `deck.rb:33-35` records a seed; `:56-58` does not log deal operations. | Cost over value: operation history adds persistent session responsibilities. |
| I13 | Conservation checks | reasoned: comparing initial multiplicities with remaining, burned, and supplied dealt cards detects missing or extra values. | Cost over value: the caller must supply dealt inventory; equal physical copies remain indistinguishable. |
| I14 | Scenario builder | reasoned: subtracting known cards from the starting multiset reconstructs a remaining population, with multiplicity preserved. | Duplicate of I7 plus existing shuffle composition. |
| I15 | Streaming binary encoding | direct: `binary_deck.rb:70` builds a complete mapped binary-text string with `join`. | Cost over value: no measured memory or throughput problem justifies the added interface. |
| I16 | Batch independent simulations | reasoned: each independent trial requires a fresh population; a helper can enforce reconstruction and seed handling. | Outside the focus: adds a simulation workflow above the deck primitives. |
| I17 | Jokers | reasoned: a distinct joker needs an identity outside ordinary rank/suit pairs; built-in support enables joker games. | Cost over value: no demand evidence justifies changes to Card and binary-format compatibility. |
| I18 | Documentation recipe only | reasoned: a recipe can teach composition without adding public compatibility obligations. | Outside the requested missing-feature result; retain as the main alternative during design. |
| I19 | Safe inspection, peek plus iteration | direct: `deck.rb:12` exposes mutable cards; `:93` converts them to strings. | Duplicate of I3 and I4; a combined inspection interface adds scope without stronger demand. |
| I21 | Reproducible simulation branches | direct: I5, I6, and I7 establish snapshot, copying, and exclusion gaps. | Cost over value: combining three speculative needs creates a larger simulation feature set. |

Paths abbreviated in this table refer to `lib/card_dealer/`, except `README.md`.

## Validation

Read-only Ruby checks confirmed contiguous repeated deals and round-robin distribution using a caller loop.

Three two-card contiguous deals produced `[["2c", "3c"], ["4c", "5c"], ["6c", "7c"]]`.

The equivalent round-robin loop produced `[["2c", "5c"], ["3c", "6c"], ["4c", "7c"]]` and left 46 cards.

A one-card deck given `deal(5, burn: 1)` returned `[]`, left zero remaining cards, and recorded the card as burned.

These checks validate the observed primitives. The proposed API has not been implemented.

### Confirmed maintenance priority

The independent verifier found that a truncated payload can decode successfully with fewer cards than its header declares. A separate local reproduction confirmed it:

```ruby
payload = [2, 0].pack("CC")
CardDealer::Deck.from_binary(payload).to_a # => ["2c"]
```

Location: `lib/card_dealer/binary_deck.rb:93-98`. The header declares two cards, but the returned deck contains one.

Cause: scanning produces available six-bit groups, and `take(deck_size)` accepts fewer groups without validating the declared count.

Proposed repair: reject incomplete payloads before returning a deck. Define a documented format error and preserve valid binary encodings.

The repair is implemented in `4376fae`. Broader malformed-input cases require a separate bounded investigation.
