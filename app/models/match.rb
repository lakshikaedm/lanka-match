class Match < ApplicationRecord
  belongs_to :user_one, class_name: "User"
  belongs_to :user_two, class_name: "User"

  has_one :conversation, dependent: :destroy
  after_create :create_conversation

  validates :user_one_id, uniqueness: { scope: :user_two_id }
  validate :users_must_be_different
  validate :ordered_user_pair

  def self.create_between(user_a, user_b)
    user_one, user_two = [ user_a, user_b ].sort_by(&:id)

    find_or_create_by(user_one: user_one, user_two: user_two)
  end

  def self.find_between(user_a, user_b)
    user_one, user_two = [ user_a, user_b ].sort_by(&:id)

    find_by(user_one: user_one, user_two: user_two)
  end

  private

  def users_must_be_different
    return if user_one_id.blank? || user_two_id.blank?

    errors.add(:user_two, "can't be the same user") if user_one_id == user_two_id
  end

  def ordered_user_pair
    return if user_one_id.blank? || user_two_id.blank?

    errors.add(:user_one_id, "must be smaller than user_two_id") unless user_one_id < user_two_id
  end
end
