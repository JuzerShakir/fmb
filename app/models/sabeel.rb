class Sabeel < ApplicationRecord
  # * Associations
  has_many :thaalis, dependent: :destroy
  has_many :transactions, through: :thaalis

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
  # name & apartment
  validates :apartment, :name, presence: true
  # Flat No
  validates :flat_no, numericality: {only_integer: true, greater_than: 0}
  # mobile
  validates :mobile, numericality: {only_integer: true}
  validates :mobile, length: {is: 10}

  # * Enums
  # apartment
  enum :apartment, %i[mohammedi saifee jamali taiyebi imadi burhani zaini fakhri badri ezzi
    maimoon_a maimoon_b qutbi_a qutbi_b najmi husami_a husami_b noorani_a
    noorani_b]

  # * Scopes
  scope :in_phase_1, -> { where(apartment: PHASE_1) }

  scope :in_phase_2, -> { where(apartment: PHASE_2) }

  scope :in_phase_3, -> { where(apartment: PHASE_3) }

  scope :active_thaalis, ->(year) { joins(:thaalis).where(thaalis: {year: year}) }

  scope :inactive_apt_thaalis, ->(apt) {
    where(apartment: apt).where("id NOT IN (
                                SELECT sabeel_id
                                FROM thaalis
                                WHERE year = #{CURR_YR}
                                )")
  }

  scope :never_taken_thaali, -> { where.missing(:thaalis) }

  scope :with_the_size, ->(size) { joins(:thaalis).where(thaalis: {size:}) }

  scope :phase_1_size, ->(size) { in_phase_1.with_the_size(size) }

  scope :phase_2_size, ->(size) { in_phase_2.with_the_size(size) }

  scope :phase_3_size, ->(size) { in_phase_3.with_the_size(size) }

  def last_year_thaali_balance_due?
    thaalis.where(year: PREV_YR, is_complete: true).any?
  end

  private

  def titleize_name
    self.name = name.split.map(&:capitalize).join(" ") unless name.nil?
  end

  def set_up_address
    self.address = "#{apartment.titleize} #{flat_no}"
  end
end
