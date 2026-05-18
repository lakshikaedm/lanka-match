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
      user_one = create(:user)
      user_two = create(:user)

      match = build(:match, user_one: user_one, user_two: user_two)
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
  end
end
