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

    building_names =  %i(mohammedi saifee jamali taiyebi imadi burhani zaini fakhri badri maimoon qutbi najmi husami noorani)

    building_names_with_ids = building_names.each_with_object({}).with_index do | (building_name, hash), i |
        hash[building_name] = i
    end

    enum :building_name, building_names_with_ids

    validates_length_of :wing, is: 1

    validates_numericality_of :flat_no, only_integer: true, greater_than: 0

    validates_numericality_of :mobile, in: 1000000000..9999999999

    validates :takes_thaali, inclusion: [true, false]

    # * Scopes
    scope :in_phase_1, -> { where(building_name: ["mohammedi", "saifee", "jamali", "taiyebi", "imadi", "burhani", "zaini", "fakhri", "badri"]) }

    scope :in_phase_2, -> { where(building_name: ["maimoon", "qutbi", "najmi"]) }

    scope :in_phase_3, -> { where(building_name: ["husami", "noorani"]) }

    scope :in_maimoon_a, -> { where(building_name: "maimoon", wing: "A") }

    scope :in_maimoon_b, -> { where(building_name: "maimoon", wing: "B") }

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
