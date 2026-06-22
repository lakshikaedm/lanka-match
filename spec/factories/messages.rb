FactoryBot.define do
  factory :message do
    conversation
    association :sender, factory: :user
    body { "Hello there" }
    read_at { nil }
  end
end
