class Sabeel < ApplicationRecord
    before_save :capitalize_hof_name

    validates :its, :mobile, numericality: { only_integer: true }, presence: true
    validates_numericality_of :its, in: 10000000..99999999
    validates_uniqueness_of :its

    validates_email_format_of :email

    validates :hof_name, uniqueness: { scope: :its }, presence: true

    validates_presence_of :building_name
    buildings_in_phase_1 = { mohammedi: 0, saifee: 1, jamali: 2, taiyebi: 3, imadi: 4, burhani: 5, zaini: 6, fakhri: 7, badri: 8 }
    buildings_in_phase_2 = { maimoon: 9, qutbi: 10, najmi:11 }
    buildings_in_phase_3 = { husami: 12, noorani: 13 }

    enum :building_name, Hash.new.merge!(buildings_in_phase_1, buildings_in_phase_2, buildings_in_phase_3)

    validates :address, presence: true, format: { with: /\A[a-z]+ [a-z]+ \d+\z/i }

    validates_numericality_of :mobile, in: 1000000000..9999999999

    validates :takes_thaali, inclusion: [true, false]

    private

        def capitalize_hof_name
            self.hof_name  = self.hof_name.split(" ").map(&:capitalize).join(" ")
        end
end
