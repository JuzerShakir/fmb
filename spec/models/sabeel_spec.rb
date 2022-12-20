require "rails_helper"
require "validates_email_format_of/rspec_matcher"

RSpec.describe Sabeel, :type => :model do
    subject { build(:sabeel) }
    phase_1_apts = %i(mohammedi saifee jamali taiyebi imadi burhani zaini fakhri badri ezzi)
    phase_2_apts = %i(maimoon_a maimoon_b qutbi_a qutbi_b najmi)
    phase_3_apts = %i(husami_a husami_b noorani_a noorani_b)

    context "assocaition" do
        it { should have_one(:thaali).dependent(:destroy) }
        it { should have_many(:takhmeens).through(:thaali) }
    end

    context "validations of attribute" do
        context "ITS" do
            it { should validate_numericality_of(:its).only_integer }

            it { should validate_numericality_of(:its).is_in(10000000..99999999) }

            it { should validate_uniqueness_of(:its) }

            it { should validate_presence_of(:its) }
        end

        context "email" do
            it { should validate_email_format_of(:email) }
            it { should allow_value(nil).for(:email) }
        end

        context "hof_name" do
            it { should validate_presence_of(:hof_name) }

            it { should validate_uniqueness_of(:hof_name).scoped_to(:its) }
        end

        context "apartment" do
            let(:all_apartments) { Array.new.push(*phase_1_apts, *phase_2_apts, *phase_3_apts) }

            it { should validate_presence_of(:apartment) }

            it { should define_enum_for(:apartment).with_values(all_apartments) }
        end

        context "flat_no" do
            it { should validate_numericality_of(:flat_no).only_integer }

            it { should validate_presence_of(:flat_no) }

            it { should validate_numericality_of(:flat_no).is_greater_than(0) }
        end

        context "mobile" do
            it { should validate_numericality_of(:mobile).only_integer }

            it { should validate_numericality_of(:mobile).is_in(1000000000..9999999999) }

            it { should validate_presence_of(:mobile) }

        end

        context "takes_thaali" do
            # NOT RECOMMENDED BY SHOULDA-MATCHERS GEM
            # it { should validate_inclusion_of(:takes_thaali).in_array([true, false]) }

            it "should default to false after creating a sabeel instance" do
                subject.save
                expect(subject.takes_thaali).not_to be
            end
        end

    end

    context "callback method" do
        context "#titleize_hof_name" do
            it { is_expected.to callback(:titleize_hof_name).before(:save).if(:will_save_change_to_hof_name?) }

            it "must return capitalized name" do
                subject.hof_name = Faker::Name.name.swapcase
                name_titleize_format = subject.hof_name.swapcase.titleize
                expect(subject).to receive(:titleize_hof_name).and_return(name_titleize_format)
                subject.save
            end
        end

        context "#set_up_address" do
            it { is_expected.to callback(:set_up_address).before(:save) }

            it "must be in a specific format" do
                expect(subject).to receive(:set_up_address).and_return(/\A[a-z]+ [a-z]{1} \d+\z/i)
                subject.save
            end
        end
    end

    context "scope" do
        let(:phase_1) { create_list(:sabeels_in_phase_1, 5) }
        let(:phase_2) { create_list(:sabeels_in_phase_2, 5) }
        let(:phase_3) { create_list(:sabeels_in_phase_3, 5) }

        context "Phases" do
            context ".in_phase_1" do
                it "should ONLY return all the sabeels of Phase 1 apartments" do
                    expect(described_class.in_phase_1).to contain_exactly(*phase_1)
                end

                it "should NOT return sabeels of other Phases, except for Phase 1" do
                    expect(described_class.in_phase_1).not_to contain_exactly(*phase_2, *phase_3)
                end
            end

            context ".in_phase_2" do
                it "should ONLY return all the sabeels of Phase 2 apartments" do
                    expect(described_class.in_phase_2).to contain_exactly(*phase_2)
                end
                it "should NOT return sabeels of other Phases, except for Phase 2" do
                    expect(described_class.in_phase_2).not_to contain_exactly(*phase_1, *phase_3)
                end
            end

            context ".in_phase_3" do
                it "should ONLY return all the sabeels of Phase 3 apartments" do
                    expect(described_class.in_phase_3).to contain_exactly(*phase_3)
                end

                it "should NOT return sabeels of other Phases, except for Phase 3" do
                    expect(described_class.in_phase_3).not_to contain_exactly(*phase_1, *phase_2)
                end
            end
        end

        context "for thaali" do
            let!(:sabeels_who_takes_thaali) { create_list(:sabeel_with_thaali, 2) }
            let!(:sabeels_who_doesnt_take_thaali) { create_list(:sabeel, 2) }

            context ".who_takes_thaali" do
                it "should ONLY return all sabeels who takes thaali" do
                    expect(described_class.who_takes_thaali).to contain_exactly(*sabeels_who_takes_thaali)
                end
            end

            context ".who_doesnt_takes_thaali" do
                it "should ONLY return all sabeels who DOES NOT takes thaali" do
                    expect(described_class.who_doesnt_takes_thaali).to contain_exactly(*sabeels_who_doesnt_take_thaali)
                end
            end

            context "in phase 1" do
                context ".phase_1_thaali_size" do
                    it "should ONLY return all the thaalis of small size of Phase 1" do
                        phase_1.first(3).each do | sabeel |
                            create(:thaali, sabeel: sabeel, size: "small")
                        end

                        expect(described_class.phase_1_thaali_size("small")).to contain_exactly(*phase_1.first(3))
                    end

                    it "should NOT return thaalis of other sizes of Phase 1" do
                        phase_1.last(2).map do | sabeel |
                            create(:thaali, sabeel: sabeel, size: %i(medium large).sample )
                        end

                        expect(described_class.phase_1_thaali_size("small")).not_to contain_exactly(*phase_1.last(2))
                    end
                end
            end
        end
    end
end