# * Global variables
$PHASE_1 = %w(mohammedi saifee jamali taiyebi imadi burhani zaini fakhri badri ezzi)
$PHASE_2 = %w(maimoon_a maimoon_b qutbi_a qutbi_b najmi)
$PHASE_3 = %w(husami_a husami_b noorani_a noorani_b)

FactoryBot.define do

  factory :sabeel do
    its { Faker::Number.number(digits: 8) }
    hof_name { Faker::Name.name }
    apartment { Array.new.push(*$PHASE_1, *$PHASE_2, *$PHASE_3).sample }
    flat_no { Faker::Number.within(range: 1..9999) }
    address { "#{apartment} #{flat_no}" }
    mobile { Faker::Number.number(digits: 10) }
    email { Faker::Internet.free_email }
    takes_thaali { false }

    trait :with_thaali do
      takes_thaali { true }
    end

    trait :in_phase_1 do
      apartment { $PHASE_1.sample }
    end

    trait :in_phase_2 do
      apartment { $PHASE_2.sample }
    end

    trait :in_phase_3 do
      apartment { $PHASE_3.sample }
    end

    factory :sabeel_with_thaali, traits: [:with_thaali]
    factory :sabeel_in_phase_1, traits: [:in_phase_1]
    factory :sabeel_in_phase_2, traits: [:in_phase_2]
    factory :sabeel_in_phase_3, traits: [:in_phase_3]

  end
end
