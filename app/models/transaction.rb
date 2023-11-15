class Transaction < ApplicationRecord
  default_scope { order(date: :desc) }

  # * Associations
  belongs_to :thaali

  # * RANSACK
  include Ransackable
  RANSACK_ATTRIBUTES = %w[recipe_no]

  # * FRIENDLY_ID
  include HasFriendlyId

  def sluggables
    [recipe_no]
  end

  # * Enums
  enum :mode, MODES

  # * Scopes
  scope :that_occured_on, ->(date) { where(date: date) }

  # * Validations
  validates :amount, :recipe_no, numericality: {only_integer: true, greater_than: 0}
  validate :amount_to_be_less_than_balance, if: :will_save_change_to_amount?
  validates_date :date, on_or_before: :today, if: :will_save_change_to_date?
  validates :mode, :date, presence: true
  validates :recipe_no, uniqueness: true

  private

  # * Custom Validations
  def amount_to_be_less_than_balance
    return if amount.nil?
    balance = persisted? ? amount_was + thaali.balance : thaali.balance

    if amount > balance
      errors.add(:amount, "cannot be greater than the balance")
    end
  end
end
