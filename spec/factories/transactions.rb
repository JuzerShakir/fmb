FactoryBot.define do
  factory :transaction do
    takhmeen { nil }
    mode { 1 }
    amount { 1 }
    on_date { "2022-12-17" }
  end
end
