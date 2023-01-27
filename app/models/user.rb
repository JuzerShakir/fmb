class User < ApplicationRecord
    has_secure_password

    # * FRIENDLY_ID
    extend FriendlyId
    friendly_id :its, use: [:slugged, :finders, :history]

    def should_generate_new_friendly_id?
      its_changed?
    end

    # * Validations
    # ITS
    validates_presence_of :its, :name, :password_confirmation, message: "cannot be blank"
    validates_numericality_of :its, only_integer: true, message: "must be a number"
    validates_numericality_of :its, in: 10000000..99999999, message: "is invalid"
    validates_uniqueness_of :its, message: "has already been registered"

    # name
    validates_length_of :name, minimum: 3, message: "must be more than 3 characters"
    validates_length_of :name, maximum: 35, message: "must be less than 35 characters"

    # password
    validates_length_of :password, minimum: 6, message: "must be more than 6 characters"
end
