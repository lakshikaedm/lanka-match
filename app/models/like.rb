class Like < ApplicationRecord
  belongs_to :liker, class_name: "User"
  belongs_to :liked, class_name: "User"

  validates :liker_id, uniqueness: { scope: :liked_id }
  validate :cannot_like_self

  private

  def cannot_like_self
    return if liker_id != liked_id

    errors.add(:liked_id, "cannot be the same as liker")
  end
end
