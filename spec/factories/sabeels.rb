FactoryBot.define do
  factory :sabeel do
    sequence(:its, 12345678)
    hof_name { '  jUZER SHaBBir ShaKIR  ' }
    building_name { "maimoon" }
    wing { 'A' }
    sequence(:flat_no, 1)
    address { "#{building_name} #{wing} #{flat_no}" }
    sequence(:mobile, 1234567890)
    sequence(:email, 1) { |n| "email#{n}@gmail.com" }
    takes_thaali { false }
  end
end
