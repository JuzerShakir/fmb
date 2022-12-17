class Thaali < ApplicationRecord
  belongs_to :sabeel

  after_create :set_takes_thaali_true
  after_destroy :set_takes_thaali_false

  validates_numericality_of :number, only_integer: true, greater_than: 0

  validates_uniqueness_of :number, :sabeel_id

  validates_presence_of :number, :size

  enum :size, { small: 0, medium: 1, large: 2 }

  private
    def set_takes_thaali_true
      self.sabeel.update_attribute(:takes_thaali, true)
    end

    def set_takes_thaali_false
      self.sabeel.update_attribute(:takes_thaali, false)
    end
end