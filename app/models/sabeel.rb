class Sabeel < ApplicationRecord
    has_one :thaali

    before_save  :generate_address
    after_validation :capitalize_wing, :capitalize_hof_name

    validates :its, :mobile, numericality: { only_integer: true }, presence: true
    validates_numericality_of :its, in: 10000000..99999999
    validates_uniqueness_of :its

    validates_email_format_of :email, allow_blank: true

    validates :hof_name, uniqueness: { scope: :its }, presence: true

    validates_presence_of :building_name, :wing, :flat_no
    buildings_in_phase_1 = { mohammedi: 0, saifee: 1, jamali: 2, taiyebi: 3, imadi: 4, burhani: 5, zaini: 6, fakhri: 7, badri: 8 }
    buildings_in_phase_2 = { maimoon: 9, qutbi: 10, najmi:11 }
    buildings_in_phase_3 = { husami: 12, noorani: 13 }
    enum :building_name, Hash.new.merge!(buildings_in_phase_1, buildings_in_phase_2, buildings_in_phase_3)

    validates_length_of :wing, is: 1

    validates_numericality_of :flat_no, only_integer: true, greater_than: 0

    validates_numericality_of :mobile, in: 1000000000..9999999999

    validates :takes_thaali, inclusion: [true, false]

    private

        def capitalize_hof_name
            self.hof_name  = self.hof_name.split(" ").map(&:capitalize).join(" ") unless self.hof_name.nil?
        end

        def generate_address
            self.address = "#{self.building_name.capitalize} #{self.wing} #{self.flat_no}"
        end

        def capitalize_wing
            self.wing = self.wing.upcase unless self.wing.nil?
        end
end
