class Sabeel < ApplicationRecord
  # * Global variables
  $phase_1 = %w[mohammedi saifee jamali taiyebi imadi burhani zaini fakhri badri ezzi]
  $phase_2 = %w[maimoon_a maimoon_b qutbi_a qutbi_b najmi]
  $phase_3 = %w[husami_a husami_b noorani_a noorani_b]

  # * Associations
  has_many :thaali_takhmeens, dependent: :destroy
  has_many :transactions, through: :thaali_takhmeens

  # * Callbacks
  before_save :set_up_address
  before_save :titleize_name, if: :will_save_change_to_name?

  # * FRIENDLY_ID
  include ITSFriendlyId

  # * RANSACK
  ransacker :its do
    Arel.sql("to_char(\"#{table_name}\".\"its\", '99999999')")
  end

  # * Validations
  # ITS
  include ITSValidation
  # Email
  validates_email_format_of :email, allow_blank: true, message: "is in invalid format"
  # name
  validates_uniqueness_of :name, scope: :its, message: "has already been registered with this ITS number"
  # apartment
  validates_presence_of :apartment, :name, message: "cannot be blank"
  # Flat No
  validates_numericality_of :flat_no, only_integer: true, message: "must be a number"
  validates_numericality_of :flat_no, greater_than: 0, message: "must be greater than 0"
  # mobile
  validates_numericality_of :mobile, only_integer: true, message: "must be a number"
  validates_numericality_of :mobile, in: 1_000_000_000..9_999_999_999, message: "is in invalid format"

  # * Enums
  # apartment
  enum :apartment, %i[mohammedi saifee jamali taiyebi imadi burhani zaini fakhri badri ezzi
    maimoon_a maimoon_b qutbi_a qutbi_b najmi husami_a husami_b noorani_a
    noorani_b]

  # * Scopes
  scope :in_phase_1, -> { where(apartment: $phase_1) }

  scope :in_phase_2, -> { where(apartment: $phase_2) }

  scope :in_phase_3, -> { where(apartment: $phase_3) }

  scope :active_takhmeen, ->(current_year) { joins(:thaali_takhmeens).where(thaali_takhmeens: {year: current_year}) }

  scope :inactive_takhmeen, ->(apt) {
    where(apartment: apt).where("id NOT IN (
                                SELECT sabeel_id
                                FROM thaali_takhmeens
                                WHERE year = #{$active_takhmeen}
                                )")
  }

  scope :never_done_takhmeen, -> { where.missing(:thaali_takhmeens) }

  scope :with_the_size, ->(size) { joins(:thaali_takhmeens).where(thaali_takhmeens: {size:}) }

  scope :phase_1_size, ->(size) { in_phase_1.with_the_size(size) }

  scope :phase_2_size, ->(size) { in_phase_2.with_the_size(size) }

  scope :phase_3_size, ->(size) { in_phase_3.with_the_size(size) }

  def takhmeen_complete_of_last_year(year)
    thaali_takhmeens.where(year: year - 1, is_complete: true).any?
  end

  private

  def titleize_name
    self.name = name.split(" ").map(&:capitalize).join(" ") unless name.nil?
  end

  def set_up_address
    self.address = "#{apartment.titleize} #{flat_no}"
  end
end
