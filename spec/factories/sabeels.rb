# frozen_string_literal: true

FactoryBot.define do
  factory :sabeel do
    its { Faker::Number.number(digits: 8) }

    name { Faker::Name.name }
    apartment { Sabeel.apartments.keys.sample }
    flat_no { Faker::Number.within(range: 1..9999) }
    mobile { Faker::Number.number(digits: 10) }
    email { Faker::Internet.free_email }

    trait :in_phase_1 do
      apartment { PHASE_1.sample }
    end

    trait :in_phase_2 do
      apartment { PHASE_2.sample }
    end

    trait :in_phase_3 do
      apartment { PHASE_3.sample }
    end

    trait :in_burhani do
      apartment { "burhani" }
    end

    trait :associate_with_active_takhmeen do
      thaali_takhmeens { [association(:active_takhmeen)] }
    end

    trait :associate_with_previous_takhmeen do
      thaali_takhmeens { [association(:previous_takhmeen)] }
    end

    trait :associate_with_small_thaali do
      thaali_takhmeens { [association(:small_thaali)] }
    end

    trait :associate_with_large_thaali do
      thaali_takhmeens { [association(:large_thaali)] }
    end

    factory :sabeel_phase1, traits: [:in_phase_1]
    factory :sabeel_phase2, traits: [:in_phase_2]
    factory :sabeel_phase3, traits: [:in_phase_3]

    factory :sabeel_phase1_small, traits: [:associate_with_small_thaali, :in_phase_1]

    factory :sabeel_phase1_large do
      associate_with_large_thaali
      in_phase_1
    end

    factory :sabeel_phase2_small do
      associate_with_small_thaali
      in_phase_2
    end

    factory :sabeel_phase2_large do
      associate_with_large_thaali
      in_phase_2
    end

    factory :sabeel_phase3_small do
      associate_with_small_thaali
      in_phase_3
    end

    factory :sabeel_phase3_large do
      associate_with_large_thaali
      in_phase_3
    end

    factory :active_sabeel do
      associate_with_active_takhmeen
    end

    factory :inactive_sabeel do
      associate_with_previous_takhmeen
    end

    factory :sabeel_small_thaali do
      associate_with_small_thaali
    end

    factory :sabeel_large_thaali do
      associate_with_large_thaali
    end

    factory :active_sabeel_burhani do
      associate_with_active_takhmeen
      in_burhani
    end

    factory :inactive_sabeel_burhani do
      associate_with_previous_takhmeen
      in_burhani
    end

    factory :sabeel_with_no_dues_pending_prev_year do
      thaali_takhmeens { [association(:prev_completed_takhmeens)] }
    end

    factory :sabeel_with_dues_pending_prev_year do
      associate_with_previous_takhmeen
    end
  end
end
