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
    validates_presence_of :name, :password_confirmation, message: "cannot be blank"
    validates_length_of :name, minimum: 3, message: "must be more than 3 characters"
    validates_length_of :name, maximum: 35, message: "must be less than 35 characters"

    # password
    validates_length_of :password, minimum: 6, message: "must be more than 6 characters"

    # role
    validates_presence_of :role, message: "selection is required"

    # * Enums
    enum :role, %i(admin member viewer)

    private
      def titleize_name
        self.name = self.name.split.map(&:capitalize).join(" ")
      end
end
