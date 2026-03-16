require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    subject(:user) { build(:user) }

    it { is_expected.to have_one(:profile).dependent(:destroy) }
  end

  describe "validations" do
    before { create(:user, email: "existing@example.com") }

    subject(:user) { build(:user) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

    it { is_expected.to allow_value("test@example.com").for(:email) }
    it { is_expected.not_to allow_value("invalid_email").for(:email) }

    it { is_expected.to validate_length_of(:password).is_at_least(6) }
  end
end
