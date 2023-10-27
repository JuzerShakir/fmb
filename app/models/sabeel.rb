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

  scope :actively_taking_thaali, -> { thaalis.where(thaalis: {year: CURR_YR}) }

  scope :never_taken_thaali, -> { where.missing(:thaalis) }

  scope :previously_took_thaali, -> { thaalis.where.not(thaalis: {year: CURR_YR}) }

  scope :previously_took_thaali_in, ->(apartment) { previously_took_thaali.where(apartment:) }

  scope :taking_thaali_in_year, ->(year) { thaalis.where(thaalis: {year:}) }

  scope :thaalis, -> { joins(:thaalis) }

  scope :with_the_size, ->(size) { thaalis.where(thaalis: {size:}) }

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
