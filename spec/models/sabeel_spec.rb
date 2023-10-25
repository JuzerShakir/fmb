# frozen_string_literal: true

require "rails_helper"
require "validates_email_format_of/rspec_matcher"

RSpec.describe Sabeel do
  subject(:sabeel) { build(:sabeel) }

  context "with association" do
    it { is_expected.to have_many(:thaalis).dependent(:destroy) }
    it { is_expected.to have_many(:transactions).through(:thaalis) }
  end

  context "when validating" do
    context "with ITS" do
      it { is_expected.to validate_numericality_of(:its).only_integer.with_message("must be an integer") }

      it "length" do
        sabeel.its = "123456789"
        sabeel.save
        expect(sabeel.errors[:its]).to include("is incorrect")
      end

      it { is_expected.to validate_uniqueness_of(:its).with_message("has already been registered") }
    end

    context "with email" do
      it { is_expected.to validate_email_format_of(:email).with_message("is in invalid format") }
      it { is_expected.to allow_value(nil).for(:email) }
    end

    context "with name" do
      it { is_expected.to validate_presence_of(:name) }
    end

    context "with apartment" do
      let(:all_apartments) { described_class.apartments.keys }

      it { is_expected.to validate_presence_of(:apartment).with_message("selection is required") }

      it { is_expected.to define_enum_for(:apartment).with_values(all_apartments) }
    end

    context "with flat_no" do
      it { is_expected.to validate_numericality_of(:flat_no).only_integer.with_message("must be an integer") }

      it { is_expected.to validate_numericality_of(:flat_no).is_greater_than(0) }
    end

    context "with mobile" do
      it { is_expected.to validate_numericality_of(:mobile).only_integer.with_message("must be an integer") }

      it "length" do
        sabeel.mobile = 12345678901
        sabeel.save
        expect(sabeel.errors[:mobile]).not_to be_empty
      end
    end
  end

  context "when saving" do
    describe "#titleize_name" do
      it { is_expected.to callback(:titleize_name).before(:save).if(:will_save_change_to_name?) }

      it "must return capitalized name" do
        sabeel.name = Faker::Name.name.swapcase
        name_titleize_format = sabeel.name.split.map(&:capitalize).join(" ")
        sabeel.save
        expect(sabeel.name).to eq(name_titleize_format)
      end
    end

    describe "#set_up_address" do
      it { is_expected.to callback(:set_up_address).before(:save) }

      it "must be in a specific format" do
        sabeel.save
        expect(sabeel.address).to match(/\A[a-z]+\s[a-z]?\s{1}?\d+\z/i)
      end
    end
  end

  context "when using scope" do
    context "with Phases" do
      let(:phase_1_sabeel) { create(:sabeel_phase1) }
      let(:phase_2_sabeel) { create(:sabeel_phase2) }
      let(:phase_3_sabeel) { create(:sabeel_phase3) }

      describe "returns sabeels of only Phase 1" do
        subject { described_class.in_phase_1 }

        it { is_expected.to match_array(phase_1_sabeel) }
        it { is_expected.not_to match_array(phase_2_sabeel) }
      end

      describe "returns sabeels of only Phase 2" do
        subject { described_class.in_phase_2 }

        it { is_expected.to match_array(phase_2_sabeel) }
        it { is_expected.not_to match_array(phase_1_sabeel) }
      end

      describe "returns sabeels returns sabeels of only Phase 3" do
        subject { described_class.in_phase_3 }

        it { is_expected.to match_array(phase_3_sabeel) }
        it { is_expected.not_to match_array(phase_2_sabeel) }
      end
    end

    context "with thaali" do
      thaali_size = :small

      describe "returns sabeels who are currently taking thaali" do
        subject { described_class.active_thaalis(CURR_YR) }

        let(:active_sabeel) { create(:active_sabeel) }

        it { is_expected.to match_array(active_sabeel) }
      end

      describe "returns sabeels who have never taken thaali" do
        subject { described_class.never_taken_thaali }

        let(:sabeel) { create(:sabeel) }

        it { is_expected.to contain_exactly(sabeel) }
      end

      describe "returns all sabeels for the size specified" do
        subject { described_class.with_the_size(thaali_size) }

        let(:large_thaali) { create(:sabeel_large_thaali) }
        let(:small_thaali) { create(:sabeel_small_thaali) }

        it { is_expected.to match_array(small_thaali) }
        it { is_expected.not_to match_array(large_thaali) }
      end

      context "with different Phases" do
        describe "returns thaalis of Phase 1 for the given size" do
          subject { described_class.phase_1_size(thaali_size) }

          let(:phase_1_small) { create(:sabeel_phase1_small) }
          let(:phase_1_large) { create(:sabeel_phase1_large) }

          it { is_expected.to match_array(phase_1_small) }
          it { is_expected.not_to match_array(phase_1_large) }
        end

        describe "returns thaalis of Phase 2 for the given size" do
          subject { described_class.phase_2_size(thaali_size) }

          let(:phase_2_small) { create(:sabeel_phase2_small) }
          let(:phase_2_large) { create(:sabeel_phase2_large) }

          it { is_expected.to match_array(phase_2_small) }
          it { is_expected.not_to match_array(phase_2_large) }
        end

        describe "returns thaalis of Phase 3 for the given size" do
          subject { described_class.phase_3_size(thaali_size) }

          let(:phase_3_small) { create(:sabeel_phase3_small) }
          let(:phase_3_large) { create(:sabeel_phase3_large) }

          it { is_expected.to match_array(phase_3_small) }
          it { is_expected.not_to match_array(phase_3_large) }
        end
      end
    end

    context "with Apartment" do
      describe "returns sabeels who are currently not taking thaali" do
        subject(:thaali) { described_class.inactive_apt_thaalis("burhani") }

        it {
          inactive_thaali = create(:burhani_sabeel_with_previous_thaali)
          expect(thaali).to contain_exactly(inactive_thaali)
        }

        it {
          active_thaali = create(:active_sabeel_burhani)
          expect(thaali).not_to contain_exactly(active_thaali)
        }
      end
    end
  end

  context "when using instance methods" do
    describe "returns true if sabeel has NO previous year dues pending" do
      subject { sabeel.last_year_thaali_balance_due? }

      let(:sabeel) { create(:sabeel_prev_thaali_no_dues) }

      it { is_expected.to be_truthy }
    end

    describe "returns false if sabeel has previous year dues pending" do
      subject { sabeel.last_year_thaali_balance_due? }

      let(:sabeel) { create(:sabeel_with_previous_thaali) }

      it { is_expected.to be_falsy }
    end
  end
end
