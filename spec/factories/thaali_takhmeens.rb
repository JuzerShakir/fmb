FactoryBot.define do
  factory :thaali_takhmeen do
    sabeel
    year { Random.rand($current_year_takhmeen - 30..Date.today.year) }
    total  { Faker::Number.number(digits: 5) }
    balance { total - paid }
    is_complete { false }
    number { Random.rand(1..1000) }
    sequence :size, %i[small medium large].cycle

    trait :current_year do
      year { $current_year_takhmeen }
    end

    trait :previous_year do
      year { Date.today.prev_year.year }
    end

    trait :complete do
      is_complete { true }
    end

    factory :thaali_takhmeen_of_current_year, traits: [:current_year]
    factory :thaali_takhmeen_of_previous_year, traits: [:previous_year]
    factory :thaali_takhmeen_is_complete, traits: [:complete]
  end
end
