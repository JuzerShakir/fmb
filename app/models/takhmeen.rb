class Takhmeen < ApplicationRecord
  belongs_to :thaali

  before_save :set_balance

  validates_presence_of :year, :total, :paid

  validates_numericality_of :year, only_integer: true, greater_than_or_equal_to: 2022
  validates_uniqueness_of :year, { scope: :thaali_id }

  validates_numericality_of :total, only_integer: true, greater_than: 0

  validates_numericality_of :paid, only_integer: true, greater_than_or_equal_to: 0

  private
    def set_balance
      self.balance = self.total - self.paid
    end
end
