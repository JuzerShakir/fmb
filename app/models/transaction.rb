class Transaction < ApplicationRecord
  default_scope { order(date: :desc) }

  # * Associations
  belongs_to :thaali

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

  # * Custom Validations
  def amount_to_be_less_than_balance
    return if amount.nil?
    balance = persisted? ? amount_was + thaali.balance : thaali.balance

    if amount > balance
      errors.add(:amount, "cannot be greater than the balance")
    end
  end
end
