class Takhmeen < ApplicationRecord
  belongs_to :thaali

  validates_presence_of :year, :total, :paid, :is_complete, :balance

  validates_numericality_of :year, only_integer: true, greater_than_or_equal_to: 2022
  validates_uniqueness_of :year, { scope: :thaali_id }

  validates_numericality_of :total, only_integer: true, greater_than: 0

  validates_numericality_of :paid, only_integer: true, greater_than_or_equal_to: 0

  validates_numericality_of :balance, only_integer: true

end
