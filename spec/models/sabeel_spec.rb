require "rails_helper"
require "validates_email_format_of/rspec_matcher"

RSpec.describe Sabeel, :type => :model do
    subject { build(:sabeel) }

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

        context "building_name" do
            let(:phase_1) { %i(mohammedi saifee jamali taiyebi imadi burhani zaini fakhri badri) }
            let(:phase_2) { %i(maimoon qutbi najmi) }
            let(:phase_3) { %i(husami noorani) }

            let(:buildings) { Array.new.push(*phase_1, *phase_2, *phase_3) }

            it { should validate_presence_of(:building_name) }

            it { should define_enum_for(:building_name).with_values(buildings) }
        end

        context "wing" do
            it { should validate_presence_of(:wing) }

            it { should validate_length_of(:wing).is_equal_to(1) }
        end

        context "flat_no" do
            it { should validate_numericality_of(:flat_no).only_integer }

            it { should validate_presence_of(:flat_no) }

            it { should validate_numericality_of(:flat_no).is_greater_than(0) }
        end

        # context "Address" do
        #     it { should validate_presence_of(:address) }
        # end

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

        context "#upcase_wing" do
            it { is_expected.to callback(:upcase_wing).before(:save).if(:will_save_change_to_wing?) }

            it "must capitalize the character" do
                subject.wing = ('a'..'z').to_a.sample
                subject.save
                expect(subject.wing).to match(/[A-Z]{1}/)
            end
        end
    end

    context "scope" do
        phase_1 = %i(mohammedi saifee jamali taiyebi imadi burhani zaini fakhri badri)
        phase_2 = %i(maimoon qutbi najmi)
        phase_3 = %i(husami noorani)

        context ".in_phase_1" do
            it "should return all the sabeels who live in Phase 1 buildings" do
                sabeels_in_phase_1 = phase_1.map { | building | create(:sabeel, building) }
                expect(described_class.in_phase_1).to contain_exactly(*sabeels_in_phase_1)
            end

            it "should NOT return sabeels who live in different Phases" do
                expect(described_class.in_phase_1).not_to contain_exactly(described_class.in_phase_2, described_class.in_phase_3)
            end
        end

        context ".in_phase_2" do
            it "should return all the sabeels who live in Phase 2 buildings" do
                sabeels_in_phase_2 = phase_2.map { | building | create(:sabeel, building) }
                expect(described_class.in_phase_2).to contain_exactly(*sabeels_in_phase_2)
            end
            it "should NOT return sabeels who live in different Phases" do
                expect(described_class.in_phase_2).not_to contain_exactly(described_class.in_phase_1, described_class.in_phase_3)
            end
        end

        context ".in_phase_3" do
            it "should return all the sabeels who live in Phase 3 buildings" do
                sabeels_in_phase_3 = phase_3.map { | building | create(:sabeel, building) }
                expect(described_class.in_phase_3).to contain_exactly(*sabeels_in_phase_3)
            end

            it "should NOT return sabeels who live in different Phases" do
                expect(described_class.in_phase_3).not_to contain_exactly(described_class.in_phase_1, described_class.in_phase_2)
            end
        end

        context "by wings" do

            context "for maimoon" do
                let!(:sabeels_in_maimoon_b) { create_list(:sabeel, 2, :maimoon, wing: "B") }
                let!(:sabeels_in_maimoon_a) { create_list(:sabeel, 2, :maimoon, wing: "A") }

                context ".in_maimoon_a" do
                    it "should return all the sabeels who live in A wing of maimoon building" do
                        expect(described_class.in_maimoon_a).to contain_exactly(*sabeels_in_maimoon_a)
                    end

                    it "should NOT return sabeels of different wing or building" do
                        expect(described_class.in_maimoon_a).not_to contain_exactly(*sabeels_in_maimoon_b)
                    end
                end

                context ".in_maimoon_b" do
                    it "should return all the sabeels who live in A wing of maimoon building" do
                        expect(described_class.in_maimoon_b).to contain_exactly(*sabeels_in_maimoon_b)
                    end

                    it "should NOT return sabeels of different wing or building" do
                        expect(described_class.in_maimoon_b).not_to contain_exactly(*sabeels_in_maimoon_a)
                    end
                end
            end

            context "for qutbi" do
                let!(:sabeels_in_qutbi_a) { create_list(:sabeel, 2, :qutbi, wing: "A") }
                let!(:sabeels_in_qutbi_b) { create_list(:sabeel, 2, :qutbi, wing: "B") }

                context ".in_qutbi_a" do
                    it "should return all the sabeels who live in A wing of Qutbi building" do
                        expect(described_class.in_qutbi_a).to contain_exactly(*sabeels_in_qutbi_a)
                    end

                    it "should NOT return sabeels of different wing or building" do
                        expect(described_class.in_qutbi_a).not_to contain_exactly(*sabeels_in_qutbi_b)
                    end
                end
            end
        end
    end
end