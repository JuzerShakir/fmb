class Thaali < ApplicationRecord
  # * Associtions
  belongs_to :sabeel
  has_many :transactions, dependent: :destroy

  # * Enums
  enum :size, SIZES

  # * FRIENDLY_ID
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders, :history]

  def should_generate_new_friendly_id?
    number_changed?
  end

  def slug_candidates
    "#{year}-#{number}"
  end

  # * Methods
  def balance
    total - paid
  end

  def dues_cleared?
    balance.zero?
  end

  # * RANSACK
  ransacker :number do
    Arel.sql("to_char(\"#{table_name}\".\"number\", '99999999')")
  end

  # * Scopes
  scope :completed_year, ->(year) { in_the_year(year).where("total = paid") }

  scope :in_the_year, ->(year) { where(year: year).order(number: :ASC) }

  scope :pending, -> { where("total > paid").order(paid: :ASC) }

  scope :pending_year, ->(year) { pending.in_the_year(year) }

  # * Validations
  # number & total
  validates :number, :total, numericality: {only_integer: true, greater_than: 0}
  # paid
  validates :paid, numericality: {only_integer: true, greater_than_or_equal_to: 0}
  # size
  validates :size, presence: true
  # year
  validates :year, uniqueness: {scope: :sabeel_id}
  validates :year, numericality: {only_integer: true, less_than_or_equal_to: CURR_YR}
end
