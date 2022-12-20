FactoryBot.define do
  phase_1 = %i(mohammedi saifee jamali taiyebi imadi burhani zaini fakhri badri ezzi)
  phase_2 = %i(maimoon_a maimoon_b qutbi_a qutbi_b najmi)
  phase_3 = %i(husami_a husami_b noorani_a noorani_b)

  factory :sabeel do
    its { Faker::Number.number(digits: 8) }
    hof_name { Faker::Name.name }
    sequence :apartment, Array.new.push(*phase_1, *phase_2, *phase_3).cycle
    flat_no { Faker::Number.within(range: 1..9999) }
    address { "#{apartment} #{flat_no}" }
    mobile { Faker::Number.number(digits: 10) }
    email { Faker::Internet.free_email }
    takes_thaali { false }

    trait :with_thaali do
      takes_thaali { true }
    end

    trait :in_phase_1 do
      apartment { phase_1.sample }
    end

    trait :in_phase_2 do
      apartment { phase_2.sample }
    end

    trait :in_phase_3 do
      apartment { phase_3.sample }
    end

    factory :sabeel_with_thaali, traits: [:with_thaali]
    factory :sabeels_in_phase_1, traits: [:in_phase_1]
    factory :sabeels_in_phase_2, traits: [:in_phase_2]
    factory :sabeels_in_phase_3, traits: [:in_phase_3]

  end
end
