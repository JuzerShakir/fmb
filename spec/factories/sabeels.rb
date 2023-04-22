FactoryBot.define do
  factory :sabeel do
    its { Faker::Number.number(digits: 8) }
    name { Faker::Name.name }
    apartment { Sabeel.apartments.keys.sample }
    flat_no { Faker::Number.within(range: 1..9999) }
    mobile { Faker::Number.number(digits: 10) }
    email { Faker::Internet.free_email }

    trait :in_phase_1 do
      apartment { $phase_1.sample }
    end

    trait :in_phase_2 do
      apartment { $phase_2.sample }
    end

    trait :in_phase_3 do
      apartment { $phase_3.sample }
    end

    # factory :sabeel_with_thaali, traits: [:with_thaali]
    factory :sabeel_phase1, traits: [:in_phase_1]
    factory :sabeel_phase2, traits: [:in_phase_2]
    factory :sabeel_phase3, traits: [:in_phase_3]
  end
end
