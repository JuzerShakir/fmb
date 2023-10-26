class Transaction < ApplicationRecord
  # * Associations
  belongs_to :thaali

  # * Callbacks
  after_commit :add_all_transaction_amounts_to_paid_amount

  # * Enums
  enum :mode, MODES

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

  # * Scopes
  scope :that_occured_on, ->(date) { where(date: date) }

  # * Validations
  # amount
  validates :amount, :recipe_no, numericality: {only_integer: true, greater_than: 0}
  validate :amount_to_be_less_than_balance, if: :will_save_change_to_amount?
  # date
  validates_date :date, on_or_before: :today, if: :will_save_change_to_date?
  # date & mode
  validates :mode, :date, presence: true
  # recipe no
  validates :recipe_no, uniqueness: true

  private

  def add_all_transaction_amounts_to_paid_amount
    transactions = thaali.transactions
    total_paid = 0

    if transactions.any?
      total_paid = transactions.map(&:amount).sum
      thaali.update(paid: total_paid)

      # below logic won't run if thaali instance has been destroyed
    elsif thaali.persisted?
      thaali.update(paid: total_paid)
    end
  end

  # * Custom Validations
  def amount_to_be_less_than_balance
    balance = persisted? ? amount_was + thaali.balance : thaali.balance

    if amount > balance
      errors.add(:amount, "cannot be greater than the balance")
    end
  end
end
