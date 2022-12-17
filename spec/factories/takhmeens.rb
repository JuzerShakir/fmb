FactoryBot.define do
  factory :takhmeen do
    thaali
    sequence(:year, 2022)
    sequence(:total, 40000)
    paid { 0 }
    balance { total - paid }
    is_complete { false }
  end
end
