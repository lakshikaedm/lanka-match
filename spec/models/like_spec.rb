require 'rails_helper'

RSpec.describe Like, type: :model do
  subject(:like) { build(:like) }

  describe "associations" do
    it { is_expected.to belong_to(:liker).class_name("User") }
    it { is_expected.to belong_to(:liked).class_name("User") }
  end

  describe "validations" do
    subject(:duplicate_like) { create(:like, liker: liker, liked: liked) }

    let(:liker) { create(:user) }
    let(:liked) { create(:user) }

    it { is_expected.to validate_uniqueness_of(:liker_id).scoped_to(:liked_id) }

    it "is invalid when liking self" do
      self_like = build(:like, liker: liker, liked: liker)

      expect(self_like).not_to be_valid
      expect(self_like.errors[:liked_id]).to include("cannot be the same as liker")
    end
  end
end
