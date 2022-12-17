class Transaction < ApplicationRecord
  belongs_to :takhmeen

  after_commit :add_transaction_amount_to_paid_amount

  validates_presence_of :mode, :amount, :on_date

  mode_of_payments = { cash: 0, cheque: 1, bank: 2 }
  enum :mode, mode_of_payments

  validates_numericality_of :amount, only_integer: true, greater_than: 0

  validate :on_date_must_not_be_in_future

  def on_date_must_not_be_in_future
    if self.on_date.present? && (self.on_date > Date.today)
      errors.add(:on_date, "cannot be in the future")
    end
  end

  private

    def add_transaction_amount_to_paid_amount
      unless self.takhmeen.is_complete
        self.takhmeen.paid += self.amount
        self.takhmeen.update_attribute(:paid, self.takhmeen.paid)
      end
    end
end
