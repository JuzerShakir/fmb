FactoryBot.define do
  factory :takhmeen do
    thaali
    year { (Date.current.year..Date.current.next_year.year).to_a.sample }
    total { Faker::Number.number(digits: 5) }
    balance { total - paid }
  end
end
