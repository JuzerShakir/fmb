FactoryBot.define do
  factory :thaali_takhmeen do
    sabeel
    year { Random.rand($active_takhmeen - 30...Date.today.year) }
    total { Faker::Number.number(digits: 5) }
    paid { 0 }
    balance { total - paid }
    is_complete { false }
    number { Random.rand(1..10000) }
    sequence :size, ThaaliTakhmeen.sizes.keys.cycle

    trait :current_year do
      year { $active_takhmeen }
    end

    trait :previous_year do
      year { $prev_takhmeen }
    end

    trait :complete do
      total { Faker::Number.number(digits: 5) }
      paid { total }
    end

    factory :active_takhmeen, traits: [:current_year]
    factory :previous_takhmeen, traits: [:previous_year]
    factory :completed_takhmeens, traits: [:complete]
    factory :prev_completed_takhmeens, traits: [:previous_year, :complete]
    factory :active_completed_takhmeens, traits: [:current_year, :complete]
  end
end
