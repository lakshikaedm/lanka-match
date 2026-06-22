require 'rails_helper'

RSpec.describe Message, type: :model do
  describe "associations" do
    it { should belong_to(:conversation) }
    it { should belong_to(:sender).class_name("User") }
  end

  describe "validations" do
    it { should validate_presence_of(:body) }
    it { should validate_length_of(:body).is_at_most(2000) }
  end
end
