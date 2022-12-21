class ThaaliTakhmeen < ApplicationRecord
  belongs_to :sabeel

  # * Validations
  # number
  validates_numericality_of :number, only_integer: true, greater_than: 0
  validates_presence_of :number, :size
  validates_uniqueness_of :number, { scope: :year}

  # * Enums
  enum :size, { small: 0, medium: 1, large: 2 }
end
