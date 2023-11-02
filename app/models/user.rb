class User < ApplicationRecord
  rolify
  has_secure_password

  # * Callbacks
  include NameCallback

  # * FRIENDLY_ID
  include ITSFriendlyId

  # * Methods
  def role
    roles_name.join.capitalize
  end

  # * Validations
  # ITS
  include ITSValidation
  # name
  include NameValidation
  # password
  validates :password, :password_confirmation, length: {minimum: 6}
  # role
  validate :must_have_a_role

  private

  def must_have_a_role
    unless roles.any?
      errors.add(:role_ids, "selection is required")
    end
  end
end
