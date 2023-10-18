# frozen_string_literal: true

require "rails_helper"
require "validates_email_format_of/rspec_matcher"

RSpec.describe Sabeel do
  context "with association" do
    subject { build(:sabeel) }

    it { is_expected.to have_many(:thaali_takhmeens).dependent(:destroy) }
    it { is_expected.to have_many(:transactions).through(:thaali_takhmeens) }
  end

  context "when validating" do
    subject { build(:sabeel) }

    context "with ITS" do
      it { is_expected.to validate_numericality_of(:its).only_integer.with_message("must be a number") }

      it { is_expected.to validate_numericality_of(:its).is_in(10000000..99999999).with_message("is invalid") }

      it { is_expected.to validate_uniqueness_of(:its).with_message("has already been registered") }
    end

    context "with email" do
      it { is_expected.to validate_email_format_of(:email).with_message("is in invalid format") }
      it { is_expected.to allow_value(nil).for(:email) }
    end

    context "with name" do
      it { is_expected.to validate_presence_of(:name).with_message("cannot be blank") }

      it { is_expected.to validate_uniqueness_of(:name).scoped_to(:its).with_message("has already been registered with this ITS number") }
    end

    context "with apartment" do
      let(:all_apartments) { described_class.apartments.keys }

      it { is_expected.to validate_presence_of(:apartment).with_message("cannot be blank") }

      it { is_expected.to define_enum_for(:apartment).with_values(all_apartments) }
    end

    context "with flat_no" do
      it { is_expected.to validate_numericality_of(:flat_no).only_integer.with_message("must be a number") }

      it { is_expected.to validate_numericality_of(:flat_no).is_greater_than(0).with_message("must be greater than 0") }
    end

    context "with mobile" do
      it { is_expected.to validate_numericality_of(:mobile).only_integer.with_message("must be a number") }

      it { is_expected.to validate_numericality_of(:mobile).is_in(1000000000..9999999999).with_message("is in invalid format") }
    end
  end

  context "when saving" do
    subject(:sabeel) { build(:sabeel) }

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
        subject { described_class.active_takhmeen(CURR_YR) }

        let(:active_sabeel) { create(:active_sabeel) }

        it { is_expected.to match_array(active_sabeel) }
      end

      describe "returns sabeels who have never taken thaali" do
        subject { described_class.never_done_takhmeen }

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
        subject { described_class.inactive_apt_takhmeen("burhani") }

        let(:inactive_takhmeen) { create(:inactive_sabeel_burhani) }
        let(:active_takhmeen) { create(:active_sabeel_burhani) }

        it { is_expected.to contain_exactly(inactive_takhmeen) }
        it { is_expected.not_to contain_exactly(active_takhmeen) }
      end
    end
  end

  context "when using instance methods" do
    describe "returns true if sabeel has NO previous year dues pending" do
      subject { sabeel.takhmeen_complete_of_last_year? }

      let(:sabeel) { create(:sabeel_with_no_dues_pending_prev_year) }

      it { is_expected.to be_truthy }
    end

    describe "returns false if sabeel has previous year dues pending" do
      subject { sabeel.takhmeen_complete_of_last_year? }

      let(:sabeel) { create(:sabeel_with_dues_pending_prev_year) }

      it { is_expected.to be_falsy }
    end
  end
end
