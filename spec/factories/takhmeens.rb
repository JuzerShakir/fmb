FactoryBot.define do
  factory :takhmeen do
    thaali
    year { (Date.current.year..Date.current.next_year.year).to_a.sample }
    total { Faker::Number.number(digits: 5) }
    balance { total - paid }

    trait :current_year do
      year { Date.today.year }
    end

    trait :next_year do
      year { Date.today.next_year.year }
    end

    trait :complete do
      is_complete { true }
    end

    factory :takhmeen_of_current_year, traits: [:current_year]
    factory :takhmeen_of_next_year, traits: [:next_year]
    factory :takhmeen_is_complete, traits: [:complete]

  end
end
