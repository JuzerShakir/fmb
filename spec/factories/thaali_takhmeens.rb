# frozen_string_literal: true

FactoryBot.define do
  factory :thaali_takhmeen do
    sabeel
    year { Random.rand(CURR_YR - 30...Date.today.year) }
    total { Faker::Number.number(digits: 5) }
    paid { 0 }
    balance { total - paid }
    is_complete { false }
    number { Random.rand(1..10000) }
    sequence :size, ThaaliTakhmeen.sizes.keys.cycle

    trait :current_year do
      sabeel
      year { CURR_YR }
    end

    trait :previous_year do
      year { PREV_YR }
    end

    trait :complete do
      total { Faker::Number.number(digits: 5) }
      paid { total }
    end

    trait :large do
      size { "large" }
    end

    trait :small do
      size { "small" }
    end

    factory :active_takhmeen, traits: [:current_year]
    factory :previous_takhmeen, traits: [:previous_year]
    factory :completed_takhmeens, traits: [:complete]
    factory :prev_completed_takhmeens, traits: [:previous_year, :complete]
    factory :active_completed_takhmeens, traits: [:current_year, :complete]
    factory :small_thaali, traits: [:small]
    factory :large_thaali, traits: [:large]
  end
end
