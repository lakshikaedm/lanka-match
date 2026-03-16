FactoryBot.define do
  factory :profile do
    association :user
    display_name { "Lakshika" }
    birth_date { Date.new(1995, 12, 11) }
    gender { :male }
    location { "Fujinomiya" }
    bio { "Hi there" }
    occupation { "Engineer" }
  end
end
