FactoryBot.define do
  factory :takhmeen do
    thaali
    year { (Date.current.year..Date.current.next_year.year).to_a.sample }
    sequence(:total, 40000)
    balance { total - paid }
  end
end
