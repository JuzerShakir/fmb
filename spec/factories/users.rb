FactoryBot.define do
  factory :user do
    its { Faker::Number.number(digits: 8) }
    name { Faker::Name.name }
    password { Faker::Internet.password(min_length: 3, max_length: 35) }
    password_confirmation { password }


    trait :wrong_password do
      password_confirmation { "dsd" }
    end

    factory :invalid_user, traits: [:wrong_password]
  end
end