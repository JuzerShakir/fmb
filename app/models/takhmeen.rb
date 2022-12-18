class Takhmeen < ApplicationRecord
  belongs_to :thaali
  has_many :transactions

  before_save :update_balance, :check_if_balance_is_zero

  validates_presence_of :year, :total, :paid

  validates_numericality_of :year, only_integer: true, greater_than_or_equal_to: 2022
  validates_uniqueness_of :year, { scope: :thaali_id }

  validates_numericality_of :total, only_integer: true, greater_than: 0

  validates_numericality_of :paid, only_integer: true, greater_than_or_equal_to: 0

  private
    def update_balance
      self.balance = self.total - self.paid
    end

    def check_if_balance_is_zero
      self.is_complete = true if self.balance.zero? && !self.is_complete
    end
end
