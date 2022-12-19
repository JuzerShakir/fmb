class Sabeel < ApplicationRecord
    has_one :thaali, dependent: :destroy
    has_many :takhmeens, through: :thaali

    before_save  :set_up_address
    before_save :upcase_wing, if: :will_save_change_to_wing?
    before_save :titleize_hof_name, if: :will_save_change_to_hof_name?

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

    # * Scopes
    scope :in_phase_1, -> { where(building_name: buildings_in_phase_1.keys ) }

    scope :in_phase_2, -> { where(building_name: buildings_in_phase_2.keys ) }

    scope :in_phase_3, -> { where(building_name: buildings_in_phase_3.keys ) }

    private

        def titleize_hof_name
            self.hof_name  = self.hof_name.split(" ").map(&:capitalize).join(" ") unless self.hof_name.nil?
        end

        def set_up_address
            self.address = "#{self.building_name.capitalize} #{self.wing} #{self.flat_no}"
        end

        def upcase_wing
            self.wing = self.wing.upcase unless self.wing.nil?
        end
end
