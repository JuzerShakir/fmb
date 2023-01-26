class User < ApplicationRecord
    has_secure_password

    # ITS
    validates_presence_of :its, :name, message: "cannot be blank"
    validates_numericality_of :its, only_integer: true, message: "must be a number"
    validates_numericality_of :its, in: 10000000..99999999, message: "is invalid"
    validates_uniqueness_of :its, message: "has already been registered"

    # name
    validates_length_of :name, minimum: 3, message: "must be more than 3 characters"
    validates_length_of :name, maximum: 35, message: "must be less than 35 characters"
end
