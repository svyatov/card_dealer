# frozen_string_literal: true

RSpec.describe CardDealer::Card do
  subject(:card) { described_class.new(rank, suit) }

  let(:rank) { described_class::RANKS.sample }
  let(:suit) { described_class::SUITS.sample }
  let(:card_string) { "#{rank}#{suit}" }

  it "defines 13 ranks" do
    expect(described_class::RANKS.size).to eq(13)
  end

  it "defines 4 suits" do
    expect(described_class::SUITS.size).to eq(4)
  end

  it "has a rank" do
    expect(card.rank).to eq(rank)
  end

  it "has a suit" do
    expect(card.suit).to eq(suit)
  end

  it "has a string representation" do
    expect(card.to_s).to eq(card_string)
  end

  it "has an inspect representation" do
    expect(card.inspect).to eq(%(#<CardDealer::Card "#{card}">))
  end

  it "raises an error when rank is invalid" do
    expect do
      described_class.new("invalid", suit)
    end.to raise_error(described_class::InvalidRankError).with_message("Invalid rank: invalid")
  end

  it "raises an error when suit is invalid" do
    expect do
      described_class.new(rank, "invalid")
    end.to raise_error(described_class::InvalidSuitError).with_message("Invalid suit: invalid")
  end

  it "can be initialized with a string representing a card", aggregate_failures: true do
    card = described_class.new(card_string)
    expect(card.rank).to eq(rank)
    expect(card.suit).to eq(suit)
  end

  it "is equal to the card with the same rank and suit" do
    expect(card).to eq(described_class.new(rank, suit))
  end

  it "does not equal a card with a different rank" do
    new_rank = described_class::RANKS.reject { |r| r == rank }.sample
    expect(card).not_to eq(described_class.new(new_rank, suit))
  end

  it "does not equal a card with a different suit" do
    new_suit = described_class::SUITS.reject { |s| s == suit }.sample
    expect(card).not_to eq(described_class.new(rank, new_suit))
  end

  it "does not equal to any random object" do
    expect(card).not_to eq("non_card_object")
  end

  describe "#<=>" do
    let(:card) { described_class.new("5h") }

    context "when comparing the same card" do
      let(:same_card) { described_class.new("5h") }

      it "returns 0" do
        expect(card <=> same_card).to eq(0)
      end
    end

    context "when comparing to a non-card object" do
      it "returns nil" do
        expect(card <=> "non_card_object").to be_nil
      end
    end

    context "when comparing to a card with a different rank" do
      let(:lower_rank_card) { described_class.new("4h") }
      let(:higher_rank_card) { described_class.new("6h") }

      it "returns -1 if the current card has a lower rank" do
        expect(lower_rank_card <=> card).to eq(-1)
      end

      it "returns 1 if the current card has a higher rank" do
        expect(higher_rank_card <=> card).to eq(1)
      end
    end

    context "when comparing to a card with the same rank but a different suit" do
      let(:lower_suit_card) { described_class.new("5d") }
      let(:higher_suit_card) { described_class.new("5s") }

      it "returns -1 if the current card has a lower suit" do
        expect(lower_suit_card <=> card).to eq(-1)
      end

      it "returns 1 if the current card has a higher suit" do
        expect(higher_suit_card <=> card).to eq(1)
      end
    end

    it "can be sorted within an array" do
      cards = [
        described_class.new("5h"),
        described_class.new("4h"),
        described_class.new("5s"),
        described_class.new("6h"),
        described_class.new("5d")
      ]
      ordered_cards = [
        described_class.new("4h"),
        described_class.new("5d"),
        described_class.new("5h"),
        described_class.new("5s"),
        described_class.new("6h")
      ]
      expect(cards.sort).to eq(ordered_cards)
    end
  end
end
