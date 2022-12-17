FactoryBot.define do
  mode_of_payments = %i(cash cheque bank)

  factory :transaction do
    takhmeen
    sequence :mode, mode_of_payments.cycle
    sequence(:amount, 1000)
    on_date { Date.today }
  end
end
