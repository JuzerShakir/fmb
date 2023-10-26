class Sabeel < ApplicationRecord
  # * Associations
  has_many :thaalis, dependent: :destroy
  has_many :transactions, through: :thaalis

  # * Callbacks
  include NameCallback

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
  validates :mobile, numericality: {only_integer: true}, length: {is: 10}

  # * Enums
  # apartment
  enum :apartment, %i[mohammedi taiyebi burhani maimoon_a maimoon_b]

  # * Scopes
  scope :active_thaalis, ->(year) { joins(:thaalis).where(thaalis: {year:}) }

  scope :inactive_apt_thaalis, ->(apartemnt) {
    where(apartment: apartemnt).where("id NOT IN (SELECT sabeel_id FROM thaalis WHERE year = #{CURR_YR})")
  }

  scope :never_taken_thaali, -> { where.missing(:thaalis) }

  scope :with_the_size, ->(size) { joins(:thaalis).where(thaalis: {size:}) }

  def address
    "#{apartment.titleize} #{flat_no}"
  end

  def last_year_thaali_balance_due?
    thaalis.where(year: PREV_YR, is_complete: true).any?
  end
end
