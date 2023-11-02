# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    roles { [association(:role)] }
    # rubocop:disable RSpec/NoExpectationExample
    its { Faker::Number.number(digits: 8) }
    # rubocop:enable RSpec/NoExpectationExample

    name { Faker::Name.name }
    password { Faker::Internet.password(min_length: 6, max_length: 72) }
    password_confirmation { password }

    factory :admin_user do
      roles { [association(:admin)] }
    end

    factory :member_user do
      roles { [association(:member)] }
    end

    factory :viewer_user do
      roles { [association(:viewer)] }
    end

    factory :user_member_or_viewer do
      roles { [association(:member_or_viewer)] }
    end

    factory :user_admin_or_member do
      roles { [association(:admin_or_member)] }
    end

    factory :invalid_user, traits: [:wrong_password]

    # * Traits
    trait :wrong_password do
      password_confirmation { nil }
    end
  end
end
