FactoryBot.define do
  factory :user do
    its { Faker::Number.number(digits: 8) }
    name { Faker::Name.name }
    password_digest { Faker::Internet.password(min_length: 3, max_length: 35) }
  end
end