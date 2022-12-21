class ThaaliTakhmeen < ApplicationRecord
  belongs_to :sabeel

  # * Validations
  # number
  validates_numericality_of :number, :total, only_integer: true, greater_than: 0
  validates_presence_of :number, :size, :year, :total
  validates_uniqueness_of :number, { scope: :year}
  #sabeel_id
  validates_uniqueness_of :sabeel_id, { scope: :year}
  #year
  validates_numericality_of :year, only_integer: true, greater_than_or_equal_to: Date.today.year


  # * Enums
  enum :size, { small: 0, medium: 1, large: 2 }
end
