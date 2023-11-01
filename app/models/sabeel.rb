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

  # * Methods
  def address
    "#{apartment.titleize} #{flat_no}"
  end

  def taking_thaali?
    thaalis.exists? year: CURR_YR
  end

  def took_thaali?
    thaalis.exists? year: PREV_YR
  end

  def last_year_thaali_dues_cleared?
    thaalis.dues_cleared_in(PREV_YR).present?
  end

  # * RANSACK
  ransacker :its do
    Arel.sql("to_char(\"#{table_name}\".\"its\", '99999999')")
  end

  # * Scopes
  scope :no_thaali, -> { where.missing(:thaalis) }

  scope :not_taking_thaali, -> { no_thaali.union(took_thaali) }

  scope :not_taking_thaali_in, ->(apartment) { where(apartment:).not_taking_thaali.order(flat_no: :asc) }

  scope :taking_thaali, -> { thaalis.where(thaalis: {year: CURR_YR}).order(flat_no: :asc) }

  scope :taking_thaali_in_year, ->(year) { thaalis.where(thaalis: {year:}) }

  scope :thaalis, -> { joins(:thaalis) }

  scope :took_thaali, -> { thaalis.group("sabeels.id").having("MAX(thaalis.year) < #{CURR_YR}") }

  scope :with_thaali_size, ->(size) { thaalis.where(thaalis: {size:}) }

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
end
