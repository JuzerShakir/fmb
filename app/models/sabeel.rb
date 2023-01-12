class Sabeel < ApplicationRecord
    # * Global variables
    $phase_1 = %w(mohammedi saifee jamali taiyebi imadi burhani zaini fakhri badri ezzi)
    $phase_2 = %w(maimoon_a maimoon_b qutbi_a qutbi_b najmi)
    $phase_3 = %w(husami_a husami_b noorani_a noorani_b)

    # * Associations
    has_many :thaali_takhmeens, dependent: :destroy
    has_many :transactions, through: :thaali_takhmeens

    # * Callbacks
    before_save  :set_up_address
    before_save :titleize_hof_name, if: :will_save_change_to_hof_name?

    # * FRIENDLY_ID
    extend FriendlyId
    friendly_id :its, use: [:slugged, :finders, :history]

    def should_generate_new_friendly_id?
      its_changed?
    end

    # * RANSACK
    ransacker :its do
        Arel.sql("to_char(\"#{table_name}\".\"its\", '99999999')")
    end

    # * Validations
    # ITS
    validates_numericality_of :its, only_integer: true, message: "must be a number"
    validates_numericality_of :its, in: 10000000..99999999, message: "is invalid"
    validates_uniqueness_of :its, message: "has already been registered"
    # Email
    validates_email_format_of :email, allow_blank: true, message: "is in invalid format"
    # hof_name
    validates_uniqueness_of :hof_name, scope: :its, message: "has already been registered with this ITS number"
    # apartment
    validates_presence_of :apartment, :flat_no, :its, :mobile, :hof_name, message: "cannot be blank"
    # Flat No
    validates_numericality_of :flat_no, only_integer: true, message: "must be a number"
    validates_numericality_of :flat_no, greater_than: 0, message: "must be greater than 0"
    # mobile
    validates_numericality_of :mobile, only_integer: true, message: "must be a number"
    validates_numericality_of :mobile, in: 1000000000..9999999999, message: "is in invalid format"

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

    scope :active_takhmeen, -> current_year { joins(:thaali_takhmeens).where(thaali_takhmeens: {year: current_year}) }

    # doees not work
    # scope :takhmeens_other_than_the_year, -> current_year { joins(:thaali_takhmeens).where.not(thaali_takhmeens: {year: current_year}) }

    scope :never_done_takhmeen, ->{ where.missing(:thaali_takhmeens) }

    scope :with_the_size, -> size { joins(:thaali_takhmeens).where(thaali_takhmeens: {size: size}) }

    scope :phase_1_size, -> size { in_phase_1.with_the_size(size) }

    scope :phase_2_size, -> size { in_phase_2.with_the_size(size) }

    scope :phase_3_size, -> size { in_phase_3.with_the_size(size) }

    def takhmeen_complete_of_last_year(year)
        self.thaali_takhmeens.where(year: year - 1, is_complete: true).any?
    end

    private

        def titleize_hof_name
            self.hof_name  = self.hof_name.split(" ").map(&:capitalize).join(" ") unless self.hof_name.nil?
        end

        def set_up_address
            self.address = "#{self.apartment.titleize} #{self.flat_no}"
        end
end
