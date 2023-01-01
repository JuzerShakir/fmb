FactoryBot.define do
  factory :thaali_takhmeen do
    sabeel
    year { Random.rand($CURRENT_YEAR_TAKHMEEN - 30...Date.today.year) }
    total  { Faker::Number.number(digits: 5) }
    paid { 0 }
    balance { total - paid }
    is_complete { false }
    number { Random.rand(1..10000) }
    sequence :size, %i[small medium large].cycle

    trait :current_year do
      year { $CURRENT_YEAR_TAKHMEEN }
    end

    trait :previous_year do
      year { $PREV_YEAR_TAKHMEEN }
    end

    trait :complete do
      total { Faker::Number.number(digits: 5) }
      paid { total }
    end

    factory :thaali_takhmeen_of_current_year, traits: [:current_year]
    factory :thaali_takhmeen_of_previous_year, traits: [:previous_year]
    factory :thaali_takhmeen_is_complete, traits: [:complete]
    factory :thaali_takhmeen_complete_previous_year, traits: [:previous_year, :complete]
  end
end
