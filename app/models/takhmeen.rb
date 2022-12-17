class Takhmeen < ApplicationRecord
  belongs_to :thaali

  validates_presence_of :year
  validates_numericality_of :year, only_integer: true, greater_than_or_equal_to: 2022
  validates_uniqueness_of :year, { scope: :thaali_id }
end
