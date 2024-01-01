# frozen_string_literal: true

FactoryBot.define do
  factory :thaali do
    sabeel
    number { Random.rand(1..10000) }
    sequence :size, Thaali::SIZES.cycle
    total { Faker::Number.number(digits: 5) }
    year { Random.rand(1..CURR_YR) }

    # * Active
    factory :taking_thaali, traits: [:current_year]
    factory :taking_thaali_partial_amount_paid, traits: [:current_year, :associate_with_transaction]
    factory :taking_thaali_dues_cleared, traits: [:current_year, :associate_with_cleared_transaction]
    # * Last Year
    factory :took_thaali, traits: [:previous_year]
    factory :took_thaali_dues_cleared, traits: [:previous_year, :associate_with_cleared_transaction]
    # * Size
    factory :small_thaali, traits: [:small]
    factory :large_thaali, traits: [:large]

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
