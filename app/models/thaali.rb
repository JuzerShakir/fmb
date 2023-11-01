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
    transactions.map(&:amount).sum(0)
  end

  # * RANSACK
  ransacker :number do
    Arel.sql("to_char(\"#{table_name}\".\"number\", '99999999')")
  end

  # * Scopes
  scope :dues_cleared_in, ->(year) {
                            for_year(year)
                              .joins(:transactions)
                              .group("thaalis.id")
                              .having("thaalis.total = sum(transactions.amount)")
                          }

  scope :dues_unpaid, -> { no_transaction.union(partial_amount_paid) }

  scope :dues_unpaid_for, ->(year) { for_year(year).dues_unpaid }

  scope :for_year, ->(year) { where(year: year).order(number: :ASC) }

  scope :no_transaction, -> { where.missing(:transactions) }

  scope :partial_amount_paid, -> { joins(:transactions).group("thaalis.id").having("thaalis.total > sum(transactions.amount)") }

  scope :preloading, -> { preload(:sabeel, :transactions) }

  # * Validations
  # number & total
  validates :number, :total, numericality: {only_integer: true, greater_than: 0}
  # size
  validates :size, presence: true
  # year
  validates :year, uniqueness: {scope: :sabeel_id}
  validates :year, numericality: {only_integer: true, less_than_or_equal_to: CURR_YR}
end
