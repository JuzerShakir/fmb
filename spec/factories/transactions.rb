FactoryBot.define do
  factory :transaction do
    thaali_takhmeen
    sequence :mode, Transaction.modes.keys.cycle
    amount { Faker::Number.number(digits: 4) }
    date { Faker::Date.backward }
    recipe_no { Random.rand(1000..100000) }
  end
end
