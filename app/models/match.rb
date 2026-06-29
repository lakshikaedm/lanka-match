class Match < ApplicationRecord
  belongs_to :user_one, class_name: "User"
  belongs_to :user_two, class_name: "User"

  has_one :conversation, dependent: :destroy
  after_create :create_conversation

  # to prevent duplicate matches
  validates :user_one_id, uniqueness: { scope: :user_two_id }
  validate :users_must_be_different
  validate :ordered_user_pair

  # to sort ids before saving to prevent duplicate matches
  def self.create_between(user_a, user_b)
    user_one, user_two = [ user_a, user_b ].sort_by(&:id)

    find_or_create_by(user_one: user_one, user_two: user_two)
  end

  # sort ids of a matched pair before finding an existing match
  def self.find_between(user_a, user_b)
    user_one, user_two = [ user_a, user_b ].sort_by(&:id)

    find_by(user_one: user_one, user_two: user_two)
  end

  # to check the user belongs to this match
  def includes_user?(user)
    user_one_id == user.id || user_two_id == user.id
  end

  # to get other user in messages
  def other_user(user)
    user_one_id == user.id ? user_two : user_one
  end

  private

  # to prevent user from matching with themselves
  def users_must_be_different
    return if user_one_id.blank? || user_two_id.blank?

    errors.add(:user_two, "can't be the same user") if user_one_id == user_two_id
  end

  # to enforce user one id < user two id to prevent duplicate matches
  def ordered_user_pair
    return if user_one_id.blank? || user_two_id.blank?

    errors.add(:user_one_id, "must be smaller than user_two_id") unless user_one_id < user_two_id
  end
end
