class User < ApplicationRecord
  has_secure_password

  # * Callbacks
  before_save :titleize_name, if: :will_save_change_to_name?

  # * FRIENDLY_ID
  include ITSFriendlyId

  # * Validations
  # ITS
  include ITSValidation

  # name
  validates :name, length: {in: 3..35}

  # password
  validates :password, :password_confirmation, length: {minimum: 6}

  # role
  validates :role, presence: true

  # * Enums
  enum :role, %i[admin member viewer]

  private

  def titleize_name
    self.name = name.split.map(&:capitalize).join(" ")
  end
end
