class Sabeel < ApplicationRecord
    validates :its, :mobile, numericality: { only_integer: true }, uniqueness: true, presence: true
    validates :its, length: { is: 8 }

    validates_email_format_of :email

    validates :hof_name, uniqueness: true, presence: true

    validates :address, presence: true, format: { with: /\A[a-z]+ [a-z]+ \d+\z/i }

    validates :mobile, length: { is: 10 }

    validates :takes_thaali, inclusion: [true, false]
end
