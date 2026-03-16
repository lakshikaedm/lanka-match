require "rails_helper"

RSpec.describe Profile, type: :model do
  subject(:profile) { build(:profile) }

  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:display_name) }
    it { is_expected.to validate_presence_of(:birth_date) }
    it { is_expected.to validate_presence_of(:gender) }
    it { is_expected.to validate_presence_of(:location) }

    it { is_expected.to validate_length_of(:display_name).is_at_most(50) }
    it { is_expected.to validate_length_of(:bio).is_at_most(500) }
    it { is_expected.to validate_length_of(:location).is_at_most(100) }
    it { is_expected.to validate_length_of(:occupation).is_at_most(100) }

    it { is_expected.to allow_value("").for(:bio) }
    it { is_expected.to allow_value("").for(:occupation) }
  end

  describe "enum" do
    it { is_expected.to define_enum_for(:gender).with_values(male: 0, female: 1, other: 2) }
  end
end
