require 'rails_helper'

RSpec.describe Match, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user_one).class_name("User") }
    it { is_expected.to belong_to(:user_two).class_name("User") }
  end

  describe "validations" do
    subject(:match) { build(:match) }

    it { is_expected.to validate_uniqueness_of(:user_one_id).scoped_to(:user_two_id) }

    it "is valid when user_one_id is smaller than user_two_id" do
      smaller_user = create(:user)
      larger_user = create(:user)

      match = build(:match, user_one: smaller_user, user_two: larger_user)

      expect(smaller_user.id).to be < larger_user.id
      expect(match).to be_valid
    end

    it "is invalid when user_one and user_two are the same user" do
      user = create(:user)

      match = build(:match, user_one: user, user_two: user)

      expect(match).not_to be_valid
      expect(match.errors[:user_two]).to include("can't be the same user")
    end

    it "is invalid when user_one_id is greater than user_two_id" do
      smaller_user = create(:user)
      larger_user = create(:user)

      match = described_class.new(user_one: larger_user, user_two: smaller_user)
      expect(larger_user.id).to be > smaller_user.id

      expect(match).not_to be_valid
      expect(match.errors[:user_one_id]).to include("must be smaller than user_two_id")
    end

    describe ".create_between" do
      it "creates a match with ordered users" do
        smaller_user = create(:user)
        larger_user = create(:user)

        match = described_class.create_between(larger_user, smaller_user)

        expect(match).to be_persisted
        expect(match.user_one).to eq(smaller_user)
        expect(match.user_two).to eq(larger_user)
      end

      it "does not create duplicate matches for the same pair" do
        user_a = create(:user)
        user_b = create(:user)

        expect {
          described_class.create_between(user_a, user_b)
          described_class.create_between(user_b, user_a)
        }.to change(described_class, :count).by(1)
      end
    end

    describe ".find_between" do
      it "finds a match regardless of user order" do
        user_a = create(:user)
        user_b = create(:user)

        match = described_class.create_between(user_a, user_b)

        expect(described_class.find_between(user_a, user_b)).to eq(match)
        expect(described_class.find_between(user_b, user_a)).to eq(match)
      end

      it "returns nil when no match exists" do
        user_a = create(:user)
        user_b = create(:user)

        expect(described_class.find_between(user_a, user_b)).to be_nil
      end
    end
  end
end
