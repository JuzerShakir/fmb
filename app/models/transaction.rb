class Transaction < ApplicationRecord
  # * Associations
  belongs_to :thaali_takhmeen

  # * Callbacks
  after_commit :add_all_transaction_amounts_to_paid_amount

  # * Validations
  validates_presence_of :mode, :amount, :on_date

  validates_numericality_of :amount, only_integer: true, greater_than: 0

  # * Custom Validations
  validate :amount_should_be_less_than_the_balance, if: :will_save_change_to_amount?

  validate :on_date_must_not_be_in_future, if: :will_save_change_to_on_date?

  def on_date_must_not_be_in_future
    if self.on_date.present? && (self.on_date > Date.today)
      errors.add(:on_date, "cannot be in the future")
    end
  end

  def amount_should_be_less_than_the_balance
    if self.amount > self.thaali_takhmeen.balance
      errors.add(:amount, "cannot be greater than the balance")
    end
  end

  # * Enums
  mode_of_payments = { cash: 0, cheque: 1, bank: 2 }
  enum :mode, mode_of_payments

  # * Scopes
  scope :that_occured_on, -> date { where(on_date: date)}

  private

    def add_all_transaction_amounts_to_paid_amount
      unless self.thaali_takhmeen.is_complete
        takhmeen = self.thaali_takhmeen
        all_transactions_of_a_takhmeen = takhmeen.transactions

        if all_transactions_of_a_takhmeen.exists?
          total_takhmeen_paid = 0

          all_transactions_of_a_takhmeen.each do |transaction|
            total_takhmeen_paid += transaction.amount if transaction.persisted?
          end

          takhmeen.update_attribute(:paid, total_takhmeen_paid)
        else
          takhmeen.update_attribute(:paid, 0)
        end
      end
    end
end
