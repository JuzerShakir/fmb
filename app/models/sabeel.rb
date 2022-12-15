class Sabeel < ApplicationRecord
    validates :its, numericality: { only_integer: true } , length: { is: 8 }, uniqueness: true, presence: true

    validates_email_format_of :email

    validates :hof_name, uniqueness: true, presence: true

    validates :address, presence: true, format: { with: /\A[a-z]+ [a-z]+ \d+\z/i }
end
