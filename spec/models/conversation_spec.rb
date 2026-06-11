require "rails_helper"

RSpec.describe Conversation, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:match) }
  end

  describe "validations" do
    it "requires a unique match_id" do
      match = create(:match)
      duplicate = build(:conversation, match: match)

      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:match_id]).to include("has already been taken")
    end

    it "requires a status" do
      conversation = create(:match).conversation

      conversation.status = nil

      expect(conversation).not_to be_valid
      expect(conversation.errors[:status]).to include("can't be blank")
    end
  end

  describe "enums" do
    it do
      expect(described_class.statuses).to eq(
        "active" => 0,
        "closed" => 1
      )
    end
  end

  describe "database constraints" do
    it "does not allow two conversations for the same match" do
      match = create(:match)

      duplicate = Conversation.new(match: match, status: :active)

      expect {
        duplicate.save!(validate: false)
      }.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end
end
