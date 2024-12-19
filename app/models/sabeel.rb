class Sabeel < ApplicationRecord
  # * Constants
  APARTMENTS = %i[mohammedi taiyebi burhani maimoon_a maimoon_b]

  # * Defaults
  attribute :apartment, default: nil

  # * Associations
  has_many :thaalis, dependent: :destroy
  has_many :transactions, through: :thaalis

  default_scope { order(its: :asc) }

  # * Callbacks
  include NameCallback

  # * FRIENDLY_ID
  include HasFriendlyId

  def sluggables = [its]

  # * RANSACK
  include Ransackable
  RANSACK_ATTRIBUTES = %w[slug name]
  RANSACK_ASSOCIATIONS = %w[thaalis]

  include ITSValidation
  include NameValidation

  using ActiveRecordRelationExtensions
  using ArrayExtensions

  # * Enums
  enum :apartment, APARTMENTS.to_h_titleize_value

  # * Scopes
  scope :no_thaali, -> { where.missing(:thaalis) }

  scope :not_taking_thaali, -> { no_thaali.union(took_thaali) }

  scope :not_taking_thaali_in, ->(apartment) { where(apartment:).not_taking_thaali.reorder(flat_no: :asc) }

  scope :taking_thaali, -> { thaalis.where(thaalis: {year: CURR_YR}).reorder(flat_no: :asc) }

  scope :taking_thaali_in_year, ->(year) { thaalis.where(thaalis: {year:}) }

  scope :thaalis, -> { joins(:thaalis) }

  scope :took_thaali, -> { thaalis.group("sabeels.id").having("MAX(thaalis.year) < #{CURR_YR}") }

  scope :with_thaali_size, ->(size) { thaalis.where(thaalis: {size:}) }

  # * Validations
  validates :apartment, presence: true
  validates_email_format_of :email, allow_blank: true
  validates :flat_no, numericality: {only_integer: true, greater_than: 0}
  validates :mobile, numericality: {only_integer: true}, length: {is: 10}

  # * Methods
  def address = "#{apartment.titleize} #{flat_no}"

  def taking_thaali? = Rails.cache.fetch("sabeel_#{id}_taking_thaali?") { thaalis.exists? year: CURR_YR }

  def took_thaali? = Rails.cache.fetch("sabeel_#{id}_took_thaali?") { thaalis.exists? year: PREV_YR }

  def last_year_thaali_dues_cleared? = thaalis.dues_cleared_in(PREV_YR).present?
end
