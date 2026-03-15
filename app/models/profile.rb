class Profile < ApplicationRecord
  belongs_to :user

  enum :gender, { male: 0, female: 1, other: 2 }

  validates :display_name, presence: true, length: { maximum: 50 }
  validates :birth_date, presence: true
  validates :gender, presence: true
  validates :location, presence: true, length: { maximum: 100 }
  validates :bio, length: { maximum: 500 }, allow_blank: true
  validates :occupation, length: { maximum: 100 }, allow_blank: true
end
