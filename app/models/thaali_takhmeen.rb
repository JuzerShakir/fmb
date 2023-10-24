class ThaaliTakhmeen < ApplicationRecord
  # * Associtions
  belongs_to :sabeel
  has_many :transactions, dependent: :destroy

  # * Callbacks
  before_save :update_balance, :check_if_balance_is_zero

  # * FRIENDLY_ID
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders, :history]

  def slug_candidates
    "#{year}-#{number}"
  end

  # * RANSACK
  ransacker :number do
    Arel.sql("to_char(\"#{table_name}\".\"number\", '99999999')")
  end

  def should_generate_new_friendly_id?
    number_changed?
  end

  # * Validations
  # number & total
  validates :number, :total, numericality: {only_integer: true, greater_than: 0}
  # size
  validates :size, presence: true
  # year
  validates :year, uniqueness: {scope: :sabeel_id}
  validates :year, numericality: {only_integer: true, less_than_or_equal_to: CURR_YR}
  # paid
  validates :paid, numericality: {only_integer: true, greater_than_or_equal_to: 0}

  # * Enums
  enum :size, %i[small medium large]

  # * Scopes
  scope :in_the_year, ->(year) { where(year: year).order(number: :ASC) }

  scope :pending, -> { where(is_complete: false).order(balance: :DESC) }

  scope :pending_year, ->(year) { pending.in_the_year(year) }

  scope :completed_year, ->(year) { in_the_year(year).where(is_complete: true) }

  private

  def update_balance
    self.balance = total - paid
  end

  def check_if_balance_is_zero
    self.is_complete = balance.zero?
  end
end
