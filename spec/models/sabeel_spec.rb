require "rails_helper"
require "validates_email_format_of/rspec_matcher"

RSpec.describe Sabeel, type: :model do
  subject { build(:sabeel) }
  available_sizes = ThaaliTakhmeen.sizes.keys
  n = Random.rand(1..4)

  context "assocaition" do
    it { should have_many(:thaali_takhmeens).dependent(:destroy) }
    it { should have_many(:transactions).through(:thaali_takhmeens) }
  end

  context "validations of attribute" do
    context "ITS" do
      it { should validate_numericality_of(:its).only_integer.with_message("must be a number") }

      it { should validate_numericality_of(:its).is_in(10000000..99999999).with_message("is invalid") }

      it { should validate_uniqueness_of(:its).with_message("has already been registered") }
    end

    context "email" do
      it { should validate_email_format_of(:email).with_message("is in invalid format") }
      it { should allow_value(nil).for(:email) }
    end

    context "name" do
      it { should validate_presence_of(:name).with_message("cannot be blank") }

      it { should validate_uniqueness_of(:name).scoped_to(:its).with_message("has already been registered with this ITS number") }
    end

    context "apartment" do
      let(:all_apartments) { Sabeel.apartments.keys }
      it { should validate_presence_of(:apartment).with_message("cannot be blank") }

      it { should define_enum_for(:apartment).with_values(all_apartments) }
    end

    context "flat_no" do
      it { should validate_numericality_of(:flat_no).only_integer.with_message("must be a number") }

      it { should validate_numericality_of(:flat_no).is_greater_than(0).with_message("must be greater than 0") }
    end

    context "mobile" do
      it { should validate_numericality_of(:mobile).only_integer.with_message("must be a number") }

      it { should validate_numericality_of(:mobile).is_in(1000000000..9999999999).with_message("is in invalid format") }
    end
  end

  context "callback method" do
    context "#titleize_name" do
      it { is_expected.to callback(:titleize_name).before(:save).if(:will_save_change_to_name?) }

      it "must return capitalized name" do
        subject.name = Faker::Name.name.swapcase
        name_titleize_format = subject.name.split.map(&:capitalize).join(" ")
        expect(subject).to receive(:titleize_name).and_return(name_titleize_format)
        subject.save
      end
    end

    context "#set_up_address" do
      it { is_expected.to callback(:set_up_address).before(:save) }

      it "must be in a specific format" do
        subject.save
        expect(subject.address).to match(/\A[a-z]+\s[a-z]?\s{1}?\d+\z/i)
      end
    end
  end

  context "scope" do
    size = available_sizes.sample
    other_size = available_sizes.difference([size]).sample

    let(:phase_1) { create_list(:sabeel_phase1, 5) }
    let(:phase_2) { create_list(:sabeel_phase2, 5) }
    let(:phase_3) { create_list(:sabeel_phase3, 5) }

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
      let(:all_sabeels) { [*phase_1, *phase_2, *phase_3] }
      let(:current_thaali) { all_sabeels.sample(n) }
      let(:x_thaali) { all_sabeels - current_thaali }

      context ".active_takhmeen" do
        it "should ONLY return all sabeels who TAKES thaali in the CURRENT YEAR" do
          current_thaali.each do |sabeel|
            FactoryBot.create(:active_takhmeen, sabeel_id: sabeel.id)
          end

          expect(described_class.active_takhmeen(CURR_YR)).to contain_exactly(*current_thaali)
        end
      end

      context ".never_done_takhmeen" do
        it "should return ALL the sabeels who has never taken the thaali" do
          sabeel = FactoryBot.create(:sabeel)
          expect(described_class.never_done_takhmeen).to contain_exactly(sabeel)
        end
      end

      context ".with_the_size" do
        it "should ONLY return all sabeels for the thaali size specified" do
          sabeels_with_size = all_sabeels.first(n)

          sabeels_with_size.each do |sabeel|
            create(:thaali_takhmeen, sabeel:, size:)
          end

          sabeel_with_other_size = create(:thaali_takhmeen, sabeel: all_sabeels.last, size: other_size)

          output = described_class.with_the_size(size)

          expect(output).to contain_exactly(*sabeels_with_size)
          expect(output).not_to contain_exactly(*sabeel_with_other_size)
        end
      end

      context "from different Phases" do
        context ".phase_1_size" do
          it "should return all the thaalis of Phase 1 of the size specified" do
            sabeels = phase_1.first(n)

            sabeels.each do |sabeel|
              create(:thaali_takhmeen, sabeel:, size:)
            end

            sabeel_with_other_size = create(:thaali_takhmeen, sabeel: phase_1.last, size: other_size)

            output = described_class.phase_1_size(size)

            expect(output).to contain_exactly(*sabeels)
            expect(output).not_to contain_exactly(*sabeel_with_other_size)
          end
        end

        context ".phase_2_size" do
          it "should return all the thaalis of Phase 2 of the size specified" do
            sabeels = phase_2.first(n)

            sabeels.each do |sabeel|
              create(:thaali_takhmeen, sabeel:, size:)
            end

            sabeel_with_other_size = create(:thaali_takhmeen, sabeel: phase_2.last, size: other_size)

            output = described_class.phase_2_size(size)

            expect(output).to contain_exactly(*sabeels)
            expect(output).not_to contain_exactly(*sabeel_with_other_size)
          end
        end

        context ".phase_3_size" do
          it "should return all the thaalis of Phase 3 of the size specified" do
            sabeels = phase_3.first(n)

            sabeels.each do |sabeel|
              create(:thaali_takhmeen, sabeel:, size:)
            end

            sabeel_with_other_size = create(:thaali_takhmeen, sabeel: phase_3.last, size: other_size)

            output = described_class.phase_3_size(size)

            expect(output).to contain_exactly(*sabeels)
            expect(output).not_to contain_exactly(*sabeel_with_other_size)
          end
        end
      end
    end
  end

  context "class method" do
    context ".inactive_takhmeen" do
      before do
        @apt = Sabeel.apartments.keys.sample

        @active_sabeels = FactoryBot.create_list(:sabeel, n, apartment: @apt)
        @active_sabeels.each do |sabeel|
          FactoryBot.create(:active_takhmeen, sabeel:)
        end

        @inactive_sabeels = FactoryBot.create_list(:sabeel, n, apartment: @apt)
        @inactive_sabeels.each do |sabeel|
          FactoryBot.create(:previous_takhmeen, sabeel:)
        end
      end

      it "should return all the sabeels of an apt who are currently NOT TAKING thaali" do
        output = described_class.inactive_takhmeen(@apt)
        expect(output).to contain_exactly(*@inactive_sabeels)
      end

      it "should NOT return sabeels of an apt who are currently TAKING thaali" do
        output = described_class.inactive_takhmeen(@apt)
        expect(output).not_to contain_exactly(*@active_sabeels)
      end

      it "should return 'nil' if input apt name is invalid" do
        output = described_class.inactive_takhmeen(SecureRandom.alphanumeric(n))
        expect(output).to be_empty
      end
    end
  end

  context "instance methods" do
    context "#takhmeen_complete_of_last_year" do
      before do
        @sabeel = FactoryBot.create(:sabeel)
        FactoryBot.create(:active_takhmeen, sabeel_id: @sabeel.id)
      end

      it "should return TRUE if takhmeen is complete of previous year with respect to the given year" do
        FactoryBot.create(:prev_completed_takhmeens, sabeel_id: @sabeel.id)
        output = @sabeel.takhmeen_complete_of_last_year(CURR_YR)

        expect(output).to be_truthy
      end

      it "should return FALSE if takhmeen is NOT complete of previous year with respect to the given year" do
        FactoryBot.create(:previous_takhmeen, sabeel_id: @sabeel.id)
        output = @sabeel.takhmeen_complete_of_last_year(CURR_YR)

        expect(output).to be_falsy
      end
    end
  end
end
