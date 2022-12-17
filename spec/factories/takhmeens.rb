FactoryBot.define do
  factory :takhmeen do
    thaali
    sequence(:year, 2022)
    sequence(:total, 40000)
    balance { total - paid }
    is_complete { false }
  end
end
