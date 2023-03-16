class ThaaliTakhmeen < ApplicationRecord
  # * Global Variables
  $active_takhmeen = 2022
  $prev_takhmeen = $active_takhmeen - 1

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
  validates_numericality_of :number, :total, :year, :paid, only_integer: true, message: "must be a number"

  # number & total
  validates_numericality_of :number, :total, greater_than: 0, message: "must be greater than 0"
  #number
  validates_uniqueness_of :number, scope: :year, message: "has already been taken for the selected year"
  validates_presence_of :size, message: "cannot be blank"
  #year
  validates_uniqueness_of :year, scope: :sabeel_id, message: "sabeel is already taking thaali for selected year"
  validates_numericality_of :year, less_than_or_equal_to: $active_takhmeen, message: "must be less than or equal to #{$active_takhmeen}"
  #paid
  validates_numericality_of :paid, greater_than_or_equal_to: 0

  # * Enums
  enum :size, %i(small medium large)

  # * Scopes
  scope :in_the_year, -> year { where(year: year).order(number: :ASC) }

  scope :pending, -> { where(is_complete: false).order(balance: :DESC) }

  scope :pending_year, -> year { pending.in_the_year(year) }

  scope :completed_year, -> year { in_the_year(year).where(is_complete: true) }

  private

    def update_balance
      self.balance = self.total - self.paid
    end

    def check_if_balance_is_zero
      self.is_complete = self.balance.zero?
    end
end
