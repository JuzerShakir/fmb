FactoryBot.define do
  factory :sabeel do
    sequence(:its, 12345678)
    hof_name { '  jUZER SHaBBir ShaKIR  ' }
    sequence(:address, 101) { |n| "BuildingName Wing #{n}" }
    sequence(:mobile, 1234567890)
    sequence(:email, 1) { |n| "email#{n}@gmail.com" }
    takes_thaali { false }
  end
end
