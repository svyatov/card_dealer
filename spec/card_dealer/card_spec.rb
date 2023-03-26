# frozen_string_literal: true

RSpec.describe CardDealer::Card do
  subject(:card) { described_class.new(rank, suit) }

  let(:rank) { described_class::RANKS.sample }
  let(:suit) { described_class::SUITS.sample }

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
    expect(card.to_s).to eq("#{rank}#{suit}")
  end
end
