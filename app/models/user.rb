class User < ApplicationRecord
  has_secure_password

  # * Callbacks
  include NameCallback

  # * Enums
  enum :role, ROLES

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
end
