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

    trait :admin do
      role { "admin" }
    end

    trait :member do
      role { "member" }
    end

    trait :viewer do
      role { "viewer" }
    end

    factory :invalid_user, traits: [:wrong_password]
    factory :admin_user, traits: [:admin]
    factory :member_user, traits: [:member]
    factory :viewer_user, traits: [:viewer]

  end
end