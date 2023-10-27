# frozen_string_literal: true

FactoryBot.define do
  factory :transaction do
    thaali
    sequence :mode, MODES.cycle
    amount { Faker::Number.number(digits: 4) }
    date { Faker::Date.backward }
    recipe_no { Random.rand(1000..100000) }

    trait :today do
      date { Time.zone.now.to_date }
    end

    trait :yesterday do
      date { Time.zone.now.to_date.yesterday }
    end

    factory :today_transaction, traits: [:today]
    factory :yesterday_transaction, traits: [:yesterday]
  end
end
