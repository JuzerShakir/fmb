class ThaaliTakhmeen < ApplicationRecord
  # * Associtions
  belongs_to :sabeel

  # * Callbacks
  before_save :update_balance, :check_if_balance_is_zero
  after_create :set_takes_thaali_true

  # * Validations
  # number
  validates_numericality_of :number, :total, only_integer: true, greater_than: 0
  validates_presence_of :number, :size, :year, :total, :paid
  validates_uniqueness_of :number, { scope: :year}
  #sabeel_id
  validates_uniqueness_of :sabeel_id, { scope: :year}
  #year
  validates_numericality_of :year, only_integer: true, greater_than_or_equal_to: Date.today.year
  #paid
  validates_numericality_of :paid, only_integer: true, greater_than_or_equal_to: 0

  # * Enums
  enum :size, { small: 0, medium: 1, large: 2 }

  private

    def update_balance
      self.balance = self.total - self.paid
    end

    def check_if_balance_is_zero
      self.is_complete = true if self.balance.zero? && !self.is_complete
    end

    def set_takes_thaali_true
      self.sabeel.update_attribute(:takes_thaali, true)
    end
end
