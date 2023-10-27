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
    context "with email" do
      it { is_expected.to validate_email_format_of(:email) }
      it { is_expected.to allow_value(nil).for(:email) }
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

  context "when using scope" do
    let(:sabeel) { create(:sabeel) }
    let(:active_sabeel) { create(:active_sabeel) }

    describe ".actively_taking_thaali" do
      subject(:sabeels) { described_class.actively_taking_thaali }

      it "returns records who are actively taking thaali" do
        expect(sabeels).to include(active_sabeel)
      end

      it { expect(sabeels).not_to include(sabeel) }
    end

    describe ".taking_thaali_in_year" do
      subject(:sabeels) { described_class.taking_thaali_in_year(PREV_YR) }

      let(:prev_sabeel) { create(:sabeel_with_previous_thaali) }

      it "returns records who were taking thaali for the year provided" do
        expect(sabeels).to include(prev_sabeel)
      end

      it { expect(sabeels).not_to include(sabeel) }
    end

    describe ".never_taken_thaali" do
      subject(:sabeels) { described_class.never_taken_thaali }

      it "returns records who have never taken thaali" do
        expect(sabeels).to contain_exactly(sabeel)
      end

      it { expect(sabeels).not_to include(active_sabeel) }
    end

    describe ".with_the_size" do
      subject(:sabeels) { described_class.with_the_size(:small) }

      let(:large_thaali) { create(:sabeel_large_thaali) }
      let(:small_thaali) { create(:sabeel_small_thaali) }

      it "returns records for provided size" do
        expect(sabeels).to contain_exactly(small_thaali)
      end

      it { is_expected.not_to include(large_thaali) }
    end

    describe ".inactive_apt_thaalis" do
      subject(:sabeels) { described_class.inactive_apt_thaalis("burhani") }

      let(:prev_sabeel) { create(:burhani_sabeel_with_previous_thaali) }
      let(:active_sabeel) { create(:active_sabeel_burhani) }

      it "returns records who are currently not taking thaali" do
        expect(sabeels).to include(prev_sabeel)
      end

      it { expect(sabeels).not_to include(active_sabeel) }
    end
  end

  context "when using instance method" do
    describe "address" do
      subject { sabeel.address }

      let(:sabeel) { create(:sabeel) }

      it { is_expected.to eq "#{sabeel.apartment.titleize} #{sabeel.flat_no}" }
    end

    describe "last_year_thaali_dues_cleared?" do
      context "when sabeel has dues cleared" do
        subject { sabeel.last_year_thaali_dues_cleared? }

        let(:sabeel) { create(:sabeel_prev_thaali_dues_cleared) }

        it { is_expected.to be_truthy }
      end

      context "when sabeel has dues" do
        subject { sabeel.last_year_thaali_dues_cleared? }

        let(:sabeel) { create(:sabeel_with_previous_thaali) }

        it { is_expected.to be_falsy }
      end
    end
  end
end
