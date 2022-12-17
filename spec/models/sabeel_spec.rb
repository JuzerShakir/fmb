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
        context "capitalize_hof_name" do
            it { is_expected.to callback(:capitalize_hof_name).after(:validation) }

            it "must return capitalized name" do
                expect(subject).to receive(:capitalize_hof_name).and_return("Juzer Shabbir Shakir")
                subject.save
            end
        end

        context "generate_address" do
            it { is_expected.to callback(:generate_address).before(:save) }

            it "must be in a specific format" do
                expect(subject).to receive(:generate_address).and_return(/\A[a-z]+ [a-z]{1} \d+\z/i)
                subject.save
            end
        end

        context "capitalize_wing" do
            it { is_expected.to callback(:capitalize_wing).after(:validation) }

            it "must be capitalize the character" do
                expect(subject).to receive(:capitalize_wing).and_return(/[A-Z]{1}/)
                subject.save
            end
        end
    end

end