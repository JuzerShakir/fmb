class Sabeel < ApplicationRecord
    before_save :capitalize_hof_name

    validates :its, :mobile, numericality: { only_integer: true }, presence: true
    validates_numericality_of :its, in: 10000000..99999999
    validates_uniqueness_of :its

    validates_email_format_of :email

    validates :hof_name, uniqueness: { scope: :its }, presence: true

    validates :address, presence: true, format: { with: /\A[a-z]+ [a-z]+ \d+\z/i }

    validates_numericality_of :mobile, in: 1000000000..9999999999

    validates :takes_thaali, inclusion: [true, false]

    private

        def capitalize_hof_name
            self.hof_name  = self.hof_name.split(" ").map(&:capitalize).join(" ")
        end
end
