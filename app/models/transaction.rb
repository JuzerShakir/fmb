class Transaction < ApplicationRecord
  belongs_to :takhmeen

  after_commit :add_all_transaction_amounts_to_paid_amount

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

    def add_all_transaction_amounts_to_paid_amount
      unless self.takhmeen.is_complete
        takhmeen = self.takhmeen
        all_transactions_of_a_takhmeen = takhmeen.transactions

        if all_transactions_of_a_takhmeen.exists?
          total_takhmeen = all_transactions_of_a_takhmeen.pluck(:amount).sum(0)
          takhmeen.update_attribute(:paid, total_takhmeen)
        else
          takhmeen.update_attribute(:paid, 0)
        end
      end
    end
end
