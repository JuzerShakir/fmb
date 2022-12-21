FactoryBot.define do
  factory :thaali_takhmeen do
    sabeel
    year { Random.rand(Date.today.year..Date.today.year + 30) }
    total  { Faker::Number.number(digits: 5) }
    balance { total - paid }
    is_complete { false }
    number { Random.rand(1..1000) }
    sequence :size, %i[small medium large].cycle

    trait :current_year do
      year { Date.today.year }
    end

    trait :next_year do
      year { Date.today.next_year.year }
    end

    trait :complete do
      is_complete { true }
    end

    factory :thaali_takhmeen_of_current_year, traits: [:current_year]
    factory :thaali_takhmeen_of_next_year, traits: [:next_year]
    factory :thaali_takhmeen_is_complete, traits: [:complete]
  end
end
