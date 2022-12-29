class ThaaliTakhmeen < ApplicationRecord
  # * Global Variables
  $CURRENT_YEAR_TAKHMEEN = 2022
  $PREV_YEAR_TAKHMEEN = $CURRENT_YEAR_TAKHMEEN - 1

  # * Associtions
  belongs_to :sabeel
  has_many :transactions, dependent: :destroy

  # * Callbacks
  before_save :update_balance, :check_if_balance_is_zero
  after_create :set_takes_thaali_true
  after_destroy :set_takes_thaali_false

  # * FRIENDLY_ID
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders, :history]

  def slug_candidates
      "#{year}-#{number}"
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
  validates_presence_of :number, :size, :year, :total, :paid, message: "cannot be blank"
  #year
  validates_uniqueness_of :year, scope: :sabeel_id, message: "sabeel is already taking thaali for selected year"
  validates_numericality_of :year, less_than_or_equal_to: $CURRENT_YEAR_TAKHMEEN, message: "must be less than or equal to #{$CURRENT_YEAR_TAKHMEEN}"
  #paid
  validates_numericality_of :paid, greater_than_or_equal_to: 0

  # * Enums
  enum :size, { small: 0, medium: 1, large: 2 }

  # * Scopes
  scope :in_the_year, -> year { where(year: year).order(number: :ASC) }

  scope :all_pending_takhmeens_till_date, -> { where(is_complete: false) }

  scope :all_pending_takhmeens_for_the_year, -> year { all_pending_takhmeens_till_date.in_the_year(year) }

  private

    def update_balance
      self.balance = self.total - self.paid
    end

    def check_if_balance_is_zero
      self.is_complete = self.balance.zero?
    end

    def set_takes_thaali_true
      self.sabeel.update_attribute(:takes_thaali, true)
    end

    def set_takes_thaali_false
      self.sabeel.update_attribute(:takes_thaali, false)
    end
end
