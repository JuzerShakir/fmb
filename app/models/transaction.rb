class Transaction < ApplicationRecord
  # * Associations
  belongs_to :thaali_takhmeen

  # * Callbacks
  after_commit :add_all_transaction_amounts_to_paid_amount

  # * FRIENDLY_ID
  extend FriendlyId
  friendly_id :recipe_no, use: [:slugged, :finders, :history]

  def should_generate_new_friendly_id?
    recipe_no_changed?
  end

  # * RANSACK
  ransacker :recipe_no do
    Arel.sql("to_char(\"#{table_name}\".\"recipe_no\", '99999999')")
  end

  # * Validations
  # mode
  validates :mode, presence: true
  # date
  validates :date, presence: true
  validates_date :date, on_or_before: :today, if: :will_save_change_to_date?
  # amount
  validates :amount, :recipe_no, numericality: {only_integer: true, greater_than: 0}
  # recipe no
  validates :recipe_no, uniqueness: true

  # * Custom Validations
  validate :amount_should_be_less_than_the_balance, if: :will_save_change_to_amount?

  def amount_should_be_less_than_the_balance
    if persisted?
      balance = amount_was + thaali_takhmeen.balance
      errors.add(:amount, "cannot be greater than the balance") if amount > balance

    elsif present? && (amount > thaali_takhmeen.balance)
      errors.add(:amount, "cannot be greater than the balance")
    end
  end

  # * Enums
  enum :mode, %i[cash cheque bank]

  # * Scopes
  scope :that_occured_on, ->(date) { where(date: date) }

  private

  def add_all_transaction_amounts_to_paid_amount
    takhmeen = thaali_takhmeen
    all_transactions_of_a_takhmeen = takhmeen.transactions

    if all_transactions_of_a_takhmeen.any?
      total_takhmeen_paid = 0

      all_transactions_of_a_takhmeen.each do |transaction|
        total_takhmeen_paid += transaction.amount if transaction.persisted?
      end

      takhmeen.update(paid: total_takhmeen_paid)

    # below logic won't run if takhmeen instance has been destroyed
    elsif takhmeen.persisted?
      takhmeen.update(paid: 0)
    end
  end
end
