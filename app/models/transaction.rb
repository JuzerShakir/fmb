class Transaction < ApplicationRecord
  belongs_to :takhmeen

  validates_presence_of :mode, :amount

  mode_of_payments = { cash: 0, cheque: 1, bank: 2 }
  enum :mode, mode_of_payments

  validates_numericality_of :amount, only_integer: true, greater_than: 0
end
