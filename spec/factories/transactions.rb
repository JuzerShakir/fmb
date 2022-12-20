FactoryBot.define do
  mode_of_payments = %i(cash cheque bank)

  factory :transaction do
    takhmeen
    sequence :mode, mode_of_payments.cycle
    amount { Faker::Number.number(digits: 4) }
    on_date { Faker::Date.backward }
  end
end
