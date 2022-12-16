class Thaali < ApplicationRecord
  belongs_to :sabeel

  validates_numericality_of :number, only_integer: true, greater_than: 0

  validates_uniqueness_of :number

  validates_presence_of :number, :size

  enum :size, { small: 0, medium: 1, large: 2 }
end
