class Thaali < ApplicationRecord
  # * Associations
  belongs_to :sabeel
  has_many :takhmeens
  has_many :transactions, through: :takhmeens

  # * Callbacks
  after_create :set_takes_thaali_true
  after_destroy :set_takes_thaali_false

  # * Validations
  # number
  validates_numericality_of :number, only_integer: true, greater_than: 0
  validates_uniqueness_of :number, :sabeel_id
  validates_presence_of :number, :size

  # * Enums
  enum :size, { small: 0, medium: 1, large: 2 }

  # * Scopes
  scope :in_the_year, -> year { joins(:takhmeens).where('takhmeens.year = ?', year) }

  scope :all_pending_takhmeens_till_date, -> { joins(:takhmeens).where('takhmeens.is_complete = ?', false) }

  scope :all_pending_takhmeens_for_the_year, -> year { all_pending_takhmeens_till_date.in_the_year(year) }

  private
    def set_takes_thaali_true
      self.sabeel.update_attribute(:takes_thaali, true)
    end

    def set_takes_thaali_false
      self.sabeel.update_attribute(:takes_thaali, false)
    end
end