# frozen_string_literal: true

FactoryBot.define do
  factory :thaali do
    sabeel
    year { Random.rand(1..CURR_YR) }
    total { Faker::Number.number(digits: 5) }
    paid { 0 }
    number { Random.rand(1..10000) }
    sequence :size, SIZES.cycle

    trait :current_year do
      sabeel
      year { CURR_YR }
    end

    trait :previous_year do
      year { PREV_YR }
    end

    trait :cleared do
      total { Faker::Number.number(digits: 5) }
      paid { total }
    end

    trait :large do
      size { "large" }
    end

    trait :small do
      size { "small" }
    end

    factory :active_thaali, traits: [:current_year]
    factory :previous_thaali, traits: [:previous_year]
    factory :thaali_dues_cleared, traits: [:cleared]
    factory :prev_thaali_no_dues, traits: [:previous_year, :cleared]
    factory :active_thaali_no_dues, traits: [:current_year, :cleared]

    # * Size
    factory :small_thaali, traits: [:small]
    factory :large_thaali, traits: [:large]

    # * Transaction
    factory :thaali_with_transaction do
      transactions { [association(:transaction)] }
    end
  end
end
