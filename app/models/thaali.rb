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

  def paid
    transactions.sum(:amount)
  end

  # * RANSACK
  ransacker :number do
    Arel.sql("to_char(\"#{table_name}\".\"number\", '99999999')")
  end

  # * Scopes
  scope :completed_year, ->(year) {
                           in_the_year(year)
                             .joins(:transactions)
                             .group("thaalis.id")
                             .having("thaalis.total = sum(transactions.amount)")
                         }

  scope :in_the_year, ->(year) { where(year: year).order(number: :ASC) }

  scope :pending, -> {
                    left_joins(:transactions)
                      .group("thaalis.id")
                      .having("thaalis.total > sum(transactions.amount)")
                  }

  scope :pending_and_missing, -> { transactions_missing.union(pending) }

  scope :pending_year, ->(year) { in_the_year(year).pending_and_missing }

  scope :transactions_missing, -> { where.missing(:transactions) }

  # * Validations
  # number & total
  validates :number, :total, numericality: {only_integer: true, greater_than: 0}
  # size
  validates :size, presence: true
  # year
  validates :year, uniqueness: {scope: :sabeel_id}
  validates :year, numericality: {only_integer: true, less_than_or_equal_to: CURR_YR}
end
