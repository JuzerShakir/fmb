class Sabeel < ApplicationRecord
  # * Associations
  has_many :thaalis, dependent: :destroy
  has_many :transactions, through: :thaalis

  # * Callbacks
  include NameCallback

  # * Enums
  # apartment
  enum :apartment, APARTMENTS

  # * FRIENDLY_ID
  include ITSFriendlyId

  # * RANSACK
  ransacker :its do
    Arel.sql("to_char(\"#{table_name}\".\"its\", '99999999')")
  end

  # * Scopes
  scope :actively_taking_thaali, -> { joins(:thaalis).where(thaalis: {year: CURR_YR}) }

  scope :inactive_apt_thaalis, ->(apartemnt) {
    where(apartment: apartemnt).where("id NOT IN (SELECT sabeel_id FROM thaalis WHERE year = #{CURR_YR})")
  }

  scope :never_taken_thaali, -> { where.missing(:thaalis) }

  scope :with_the_size, ->(size) { joins(:thaalis).where(thaalis: {size:}) }

  # * Validations
  # apartment
  validates :apartment, presence: true
  # Email
  validates_email_format_of :email, allow_blank: true
  # Flat No
  validates :flat_no, numericality: {only_integer: true, greater_than: 0}
  # ITS
  include ITSValidation
  # name
  include NameValidation
  # mobile
  validates :mobile, numericality: {only_integer: true}, length: {is: 10}

  # * Methods
  def address
    "#{apartment.titleize} #{flat_no}"
  end

  def last_year_thaali_dues_cleared?
    thaalis.completed_year(PREV_YR).present?
  end
end
