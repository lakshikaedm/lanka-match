FactoryBot.define do
  factory :match do
    association :user_one, factory: :user
    association :user_two, factory: :user

    after(:build) do |match|
      next if match.user_one_id.blank? || match.user_two_id.blank?
      next if match.user_one_id < match.user_two_id

      match.user_one, match.user_two = match.user_two, match.user_one
    end
  end
end
