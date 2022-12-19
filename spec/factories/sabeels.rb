FactoryBot.define do
  phase_1 = %i(mohammedi saifee jamali taiyebi imadi burhani zaini fakhri badri ezzi)
  phase_2 = %i(maimoon qutbi najmi)
  phase_3 = %i(husami noorani)

  factory :sabeel do
    its { Faker::Number.number(digits: 8) }
    hof_name { Faker::Name.name }
    sequence :building_name, Array.new.push(*phase_1, *phase_2, *phase_3).cycle
    wing { ('A'..'Z').to_a.sample }
    flat_no { Faker::Number.within(range: 1..9999) }
    address { "#{building_name} #{wing} #{flat_no}" }
    mobile { Faker::Number.number(digits: 10) }
    email { Faker::Internet.free_email }
    takes_thaali { false }
  end
end
