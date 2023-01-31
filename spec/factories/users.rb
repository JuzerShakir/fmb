FactoryBot.define do
  factory :user do
    its { Faker::Number.number(digits: 8) }
    name { Faker::Name.name }
    role { User.roles.keys.sample}
    password { Faker::Internet.password(min_length: 6, max_length: 72) }
    password_confirmation { password }


    trait :wrong_password do
      password_confirmation { nil }
    end

    factory :invalid_user, traits: [:wrong_password]
  end
end