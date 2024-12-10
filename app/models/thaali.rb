class Thaali < ApplicationRecord
  # * Constants
  SIZES = %i[small medium large]

  attr_readonly :total, :year

  # * Defaults
  attribute :year, default: CURR_YR
  attribute :size, default: nil

  # * Associtions
  belongs_to :sabeel
  has_many :transactions, dependent: :destroy

  delegate :its, :name, to: :sabeel, prefix: :sabeel

  # * RANSACK
  include Ransackable
  RANSACK_ATTRIBUTES = %w[number]

  # * FRIENDLY_ID
  include HasFriendlyId

  def sluggables = [year, number]

  using ArrayExtensions

  # * Enums
  enum size: SIZES.to_h_titleize_value # rubocop:disable Rails/EnumSyntax

  # * Scopes
  scope :dues_cleared_in, ->(year) {
                            for_year(year)
                              .joins(:transactions)
                              .group("thaalis.id")
                              .having("thaalis.total = sum(transactions.amount)")
                          }

  scope :dues_unpaid, -> { no_transaction.union(partial_amount_paid) }

  scope :dues_unpaid_for, ->(year) { for_year(year).dues_unpaid.order(number: :asc) }

  scope :for_year, ->(year) { where(year: year).order(number: :ASC) }

  scope :no_transaction, -> { where.missing(:transactions) }

  scope :partial_amount_paid, -> { joins(:transactions).group("thaalis.id").having("thaalis.total > sum(transactions.amount)") }

  scope :preloading, -> { preload(:sabeel, :transactions) }

  # * Validations
  validates :number, :total, numericality: {only_integer: true, greater_than: 0}
  validates :size, presence: true
  validates :year, uniqueness: {scope: :sabeel_id}
  validates :year, numericality: {only_integer: true, less_than_or_equal_to: CURR_YR}

  # * Methods
  def balance = total - paid

  def dues_cleared? = balance.zero?

  def paid = transactions.filter_map { _1.amount if _1.persisted? }.sum(0)
end
