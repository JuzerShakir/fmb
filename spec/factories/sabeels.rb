FactoryBot.define do
  phase_1 = %i(mohammedi saifee jamali taiyebi imadi burhani zaini fakhri badri)
  phase_2 = %i(maimoon qutbi najmi)
  phase_3 = %i(husami noorani)

  factory :sabeel do
    sequence(:its, 12345678)
    hof_name { '  jUZER SHaBBir ShaKIR  ' }
    sequence :building_name, Array.new.push(*phase_1, *phase_2, *phase_3).cycle
    sequence(:wing, 'A')
    sequence(:flat_no, 1)
    address { "#{building_name} #{wing} #{flat_no}" }
    sequence(:mobile, 1234567890)
    sequence(:email, 1) { |n| "email#{n}@gmail.com" }
    takes_thaali { false }
  end
end
