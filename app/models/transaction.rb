class Transaction < ApplicationRecord
  # * Constants
  MODES = %i[cash cheque bank]

  default_scope { order(date: :desc) }

  # * Defaults
  attribute :mode, default: nil

  # * Associations
  belongs_to :thaali

  delegate :number, :year, :balance, to: :thaali, prefix: :thaali
  delegate :sabeel, to: :thaali

  # * RANSACK
  include Ransackable
  RANSACK_ATTRIBUTES = %w[slug]

  # * FRIENDLY_ID
  include HasFriendlyId

  def sluggables = [receipt_number]

  using ArrayExtensions

  # * Enums
  enum :mode, MODES.to_h_titleize_value

  # * Scopes
  scope :that_occured_on, ->(date) { where(date: date) }

  # * Validations
  validates :amount, :receipt_number, numericality: {only_integer: true, greater_than: 0}
  validate :amount_to_be_less_than_balance, if: :will_save_change_to_amount?
  validates_date :date, on_or_before: :today, if: :will_save_change_to_date?
  validates :mode, :date, presence: true
  validates :receipt_number, uniqueness: true

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
