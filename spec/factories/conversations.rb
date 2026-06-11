FactoryBot.define do
  factory :conversation do
    association :match
    status { :active }
  end
end
