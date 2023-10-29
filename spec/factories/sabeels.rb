# frozen_string_literal: true

FactoryBot.define do
  factory :sabeel do
    apartment { APARTMENTS.sample }
    email { Faker::Internet.free_email }
    flat_no { Faker::Number.within(range: 1..9999) }
    # rubocop:disable RSpec/NoExpectationExample
    its { Faker::Number.number(digits: 8) }
    # rubocop:enable RSpec/NoExpectationExample

    mobile { Faker::Number.number(digits: 10) }
    name { Faker::Name.name }

    # * Active
    factory :burhani_sabeel_taking_thaali, traits: [:associate_with_active_thaali, :in_burhani]
    factory :sabeel_taking_thaali, traits: [:associate_with_active_thaali]
    factory :taiyebi_sabeel_taking_thaali, traits: [:associate_with_active_thaali, :in_taiyebi]

    # * Inactive
    factory :burhani_sabeel_took_thaali, traits: [:associate_with_previous_thaali, :in_burhani]
    factory :sabeel_took_thaali, traits: [:associate_with_previous_thaali]

    # * Thaali Size
    factory :sabeel_large_thaali, traits: [:associate_with_large_thaali]
    factory :sabeel_small_thaali, traits: [:associate_with_small_thaali]

    # * Thaali with NO dues pending
    factory :sabeel_prev_thaali_dues_cleared do
      thaalis { [association(:prev_thaali_dues_cleared)] }
    end

    # * TRAITS
    trait :associate_with_active_thaali do
      thaalis { [association(:active_thaali)] }
    end

    trait :associate_with_large_thaali do
      thaalis { [association(:large_thaali)] }
    end

    trait :associate_with_previous_thaali do
      thaalis { [association(:previous_thaali)] }
    end

    trait :associate_with_small_thaali do
      thaalis { [association(:small_thaali)] }
    end

    trait :in_burhani do
      apartment { "burhani" }
    end

    trait :in_taiyebi do
      apartment { "taiyebi" }
    end
  end
end
