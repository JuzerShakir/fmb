class Sabeel < ApplicationRecord
    # * Associations
    has_one :thaali, dependent: :destroy
    has_many :takhmeens, through: :thaali

    # * Callbacks
    before_save  :set_up_address
    before_save :titleize_hof_name, if: :will_save_change_to_hof_name?

    # * Validations
    # ITS
    validates :its, :mobile, numericality: { only_integer: true }, presence: true
    validates_numericality_of :its, in: 10000000..99999999
    validates_uniqueness_of :its
    # Email
    validates_email_format_of :email, allow_blank: true
    # hof_name
    validates :hof_name, uniqueness: { scope: :its }, presence: true
    # apartment
    validates_presence_of :apartment, :flat_no
    # Flat No
    validates_numericality_of :flat_no, only_integer: true, greater_than: 0
    # mobile
    validates_numericality_of :mobile, in: 1000000000..9999999999
    # takes_thaali
    validates :takes_thaali, inclusion: [true, false]

    # * Enums
    # apartment
    all_apartments =  %i(mohammedi saifee jamali taiyebi imadi burhani zaini fakhri badri ezzi
                        maimoon_a maimoon_b qutbi_a qutbi_b najmi husami_a husami_b noorani_a noorani_b)

    all_apartments_with_ids = all_apartments.each_with_object({}).with_index do | (apartment, hash), i |
        hash[apartment] = i
    end
    enum :apartment, all_apartments_with_ids

    # * Scopes
    scope :in_phase_1, -> { where(apartment: ["mohammedi", "saifee", "jamali", "taiyebi", "imadi", "burhani", "zaini", "fakhri", "badri", "ezzi"]) }

    scope :in_phase_2, -> { where(apartment: ["maimoon_a", "maimoon_b", "qutbi_a", "qutbi_b", "najmi"]) }

    scope :in_phase_3, -> { where(apartment: ["husami_a", "husami_b", "noorani_a", "noorani_b"]) }

    # give maimoon, qubti, najmi, noorani, husami scopes to get all sabeels for multilpe wings in a building

    scope :who_takes_thaali, -> { where(takes_thaali: true) }

    scope :who_doesnt_takes_thaali, -> { where(takes_thaali: false) }

    scope :phase_1_thaali_size, -> size { in_phase_1.joins(:thaali).where(thaalis: {size: size}) }

    scope :phase_2_thaali_size, -> size { in_phase_2.joins(:thaali).where(thaalis: {size: size}) }


    private

        def titleize_hof_name
            self.hof_name  = self.hof_name.split(" ").map(&:capitalize).join(" ") unless self.hof_name.nil?
        end

        def set_up_address
            self.address = "#{self.apartment.titleize} #{self.flat_no}"
        end
end
