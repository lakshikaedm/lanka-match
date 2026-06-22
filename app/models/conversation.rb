class Conversation < ApplicationRecord
  belongs_to :match
  has_many :messages, dependent: :destroy

  enum :status, { active: 0, closed: 1 }

  validates :match_id, uniqueness: true
  validates :status, presence: true
end
