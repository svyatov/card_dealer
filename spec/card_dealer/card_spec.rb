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

  it "can be compared to another card" do
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
    expect(card).not_to eq(Object.new)
  end
end
