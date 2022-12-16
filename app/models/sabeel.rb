class Sabeel < ApplicationRecord
    validates :its, :mobile, numericality: { only_integer: true }, uniqueness: true, presence: true
    validates_numericality_of :its, greater_than_or_equal_to: 10000000, less_than_or_equal_to: 99999999

    validates_email_format_of :email

    validates :hof_name, uniqueness: true, presence: true

    validates :address, presence: true, format: { with: /\A[a-z]+ [a-z]+ \d+\z/i }

    validates_numericality_of :mobile, greater_than_or_equal_to: 1000000000, less_than_or_equal_to: 9999999999

    validates :takes_thaali, inclusion: [true, false]
end
