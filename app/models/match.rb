class Match < ApplicationRecord
  belongs_to :user_one, class_name: "User"
  belongs_to :user_two, class_name: "User"

  validates :user_one_id, uniqueness: { scope: :user_two_id }
  validate :users_must_be_different
  validate :ordered_user_pair

  private

  def users_must_be_different
    errors.add(:user_two, "can't be the same user") if user_one_id == user_two_id
  end

  def ordered_user_pair
    return if user_one_id.blank? || user_two_id.blank?

    errors.add(:user_one_id, "must be smaller than user_two_id") if user_one_id > user_two_id
  end
end
