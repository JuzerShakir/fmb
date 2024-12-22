class User < ApplicationRecord
  rolify
  has_secure_password
  has_many :sessions, dependent: :destroy

  # * Callbacks
  include NameCallback

  # * FRIENDLY_ID
  include HasFriendlyId

  def sluggables = [its]

  # * Validations
  include ITSValidation
  include NameValidation
  validates :password, :password_confirmation, length: {minimum: 6}
  validate :must_have_a_role

  # * Methods
  def role = Rails.cache.fetch("user_#{id}_role") { roles_name.first }

  def is?(type) = role == type

  private

  # * Custom Validations
  def must_have_a_role
    errors.add(:role_ids, "selection is required") unless roles.any?
  end
end
