class User < ApplicationRecord
  rolify
  has_secure_password

  # * Callbacks
  include NameCallback

  # * FRIENDLY_ID
  include ITSFriendlyId

  # * Methods
  def cache_role
    Rails.cache.fetch("user_#{id}_role") { roles_name.first }
  end

  def is?(role)
    cache_role == role
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
