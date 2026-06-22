class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :profile, dependent: :destroy

  has_many :given_likes,
            class_name: "Like",
            foreign_key: "liker_id",
            dependent: :destroy,
            inverse_of: :liker

  has_many :received_likes,
            class_name: "Like",
            foreign_key: "liked_id",
            dependent: :destroy,
            inverse_of: :liked

  has_many :sent_messages,
            class_name: "Message",
            foreign_key: :sender_id,
            dependent: :nullify
end
