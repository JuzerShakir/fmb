# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    # rubocop:disable RSpec/NoExpectationExample
    its { Faker::Number.number(digits: 8) }
    # rubocop:enable RSpec/NoExpectationExample

    name { Faker::Name.name }
    role { ROLES.sample }
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

    trait :member_or_viewer do
      role { ["member", "viewer"].sample }
    end

    trait :admin_or_member do
      role { ["member", "admin"].sample }
    end

    factory :invalid_user, traits: [:wrong_password]
    factory :admin_user, traits: [:admin]
    factory :member_user, traits: [:member]
    factory :viewer_user, traits: [:viewer]
    factory :user_other_than_admin, traits: [:member_or_viewer]
    factory :user_other_than_viewer, traits: [:admin_or_member]
  end
end
