# frozen_string_literal: true

FactoryBot.define do
  factory :thaali do
    sabeel
    number { Random.rand(1..10000) }
    sequence :size, SIZES.cycle
    total { Faker::Number.number(digits: 5) }
    year { Random.rand(1..CURR_YR) }

    # * Active
    factory :active_thaali, traits: [:current_year]
    factory :active_thaali_with_transactions, traits: [:current_year, :associate_with_transaction]
    factory :active_thaali_dues_cleared, traits: [:current_year, :associate_with_cleared_transaction]
    # * Last Year
    factory :previous_thaali, traits: [:previous_year]
    factory :prev_thaali_dues_cleared, traits: [:previous_year, :associate_with_cleared_transaction]
    # * Size
    factory :small_thaali, traits: [:small]
    factory :large_thaali, traits: [:large]
    # * Transaction
    factory :thaali_dues_cleared, traits: [:associate_with_cleared_transaction]
    factory :thaali_with_transaction, traits: [:associate_with_transaction]

    # * Traits
    trait :associate_with_transaction do
      transactions { [association(:transaction)] }
    end

    trait :associate_with_cleared_transaction do
      total { 1000 }
      transactions { [association(:cleared_transaction)] }
    end

    trait :current_year do
      sabeel
      year { CURR_YR }
    end

    trait :large do
      size { "large" }
    end

    trait :previous_year do
      year { PREV_YR }
    end

    trait :small do
      size { "small" }
    end
  end
end
