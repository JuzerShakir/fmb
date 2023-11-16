class User < ApplicationRecord
  rolify
  has_secure_password

  # * Callbacks
  include NameCallback

  # * FRIENDLY_ID
  include HasFriendlyId

  def sluggables
    [its]
  end

  # * Validations
  include ITSValidation
  include NameValidation
  validates :password, :password_confirmation, length: {minimum: 6}
  validate :must_have_a_role

  # * Methods
  def cache_role
    Rails.cache.fetch("user_#{id}_role") { roles_name.first }
  end

  def is?(role)
    cache_role == role
  end

  private

  # * Custom Validations
  def must_have_a_role
    unless roles.any?
      errors.add(:role_ids, "selection is required")
    end
  end
end
