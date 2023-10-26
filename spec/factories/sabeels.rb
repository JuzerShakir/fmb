# frozen_string_literal: true

FactoryBot.define do
  factory :sabeel do
    # rubocop:disable RSpec/NoExpectationExample
    its { Faker::Number.number(digits: 8) }
    # rubocop:enable RSpec/NoExpectationExample

    name { Faker::Name.name }
    apartment { APARTMENTS.sample }
    flat_no { Faker::Number.within(range: 1..9999) }
    mobile { Faker::Number.number(digits: 10) }
    email { Faker::Internet.free_email }

    # * Active
    factory :active_sabeel, traits: [:associate_with_active_thaali]
    factory :active_sabeel_burhani, traits: [:associate_with_active_thaali, :in_burhani]

    # * Inactive
    factory :sabeel_with_previous_thaali, traits: [:associate_with_previous_thaali]
    factory :burhani_sabeel_with_previous_thaali, traits: [:associate_with_previous_thaali, :in_burhani]

    # * Thaali Size
    factory :sabeel_small_thaali, traits: [:associate_with_small_thaali]
    factory :sabeel_large_thaali, traits: [:associate_with_large_thaali]

    # * Thaali with NO dues pending
    factory :sabeel_prev_thaali_dues_cleared do
      thaalis { [association(:prev_thaali_dues_cleared)] }
    end

    # * TRAITS
    trait :in_burhani do
      apartment { "burhani" }
    end

    trait :associate_with_active_thaali do
      thaalis { [association(:active_thaali)] }
    end

    trait :associate_with_previous_thaali do
      thaalis { [association(:previous_thaali)] }
    end

    trait :associate_with_small_thaali do
      thaalis { [association(:small_thaali)] }
    end

    trait :associate_with_large_thaali do
      thaalis { [association(:large_thaali)] }
    end
  end
end
