# frozen_string_literal: true

FactoryBot.define do
  factory :transaction do
    thaali
    amount { Faker::Number.number(digits: 4) }
    date { Faker::Date.backward }
    receipt_number { Random.rand(1000..100000) }
    sequence :mode, Transaction::MODES.cycle

    factory :cleared_transaction, traits: [:cleared]
    factory :today_transaction, traits: [:today]
    factory :yesterday_transaction, traits: [:yesterday]

    # * Traits
    trait :cleared do
      amount { 1000 }
    end

    trait :today do
      date { Time.zone.now.to_date }
    end

    trait :yesterday do
      date { Time.zone.now.to_date.yesterday }
    end
  end
end
