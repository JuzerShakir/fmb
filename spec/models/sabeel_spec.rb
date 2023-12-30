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
      it { is_expected.to validate_presence_of(:apartment).with_message("selection is required") }

      it { is_expected.to define_enum_for(:apartment).with_values(APARTMENTS).backed_by_column_of_type(:enum) }
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
    let(:active_sabeel) { create(:sabeel_taking_thaali) }
    let(:prev_sabeel) { create(:burhani_sabeel_took_thaali) }

    describe ".no_thaali" do
      subject(:sabeels) { described_class.no_thaali }

      it "returns records who have never taken thaali" do
        expect(sabeels).to contain_exactly(sabeel)
      end

      it { expect(sabeels).not_to include(active_sabeel) }
    end

    describe ".not_taking_thaali" do
      subject(:sabeels) { described_class.not_taking_thaali }

      it "returns records who are actively not taking thaali" do
        expect(sabeels).to include(prev_sabeel, sabeel)
      end

      it { expect(sabeels).not_to include(active_sabeel) }
    end

    describe ".not_taking_thaali_in" do
      subject(:sabeels) { described_class.not_taking_thaali_in("burhani") }

      let(:active_sabeel) { create(:burhani_sabeel_taking_thaali) }
      let(:taiyebi_sabeel) { create(:taiyebi_sabeel_taking_thaali) }

      it "returns records who are currently not taking thaali" do
        expect(sabeels).to include(prev_sabeel)
      end

      it { expect(sabeels).not_to include(active_sabeel) }
      it { expect(sabeels).not_to include(taiyebi_sabeel) }
    end

    describe ".taking_thaali" do
      subject(:sabeels) { described_class.taking_thaali }

      it "returns records who are actively taking thaali" do
        expect(sabeels).to include(active_sabeel)
      end

      it { expect(sabeels).not_to include(sabeel) }
    end

    describe ".taking_thaali_in_year" do
      subject(:sabeels) { described_class.taking_thaali_in_year(PREV_YR) }

      let(:prev_sabeel) { create(:sabeel_took_thaali) }

      it "returns records who were taking thaali for the year provided" do
        expect(sabeels).to include(prev_sabeel)
      end

      it { expect(sabeels).not_to include(sabeel) }
    end

    describe ".took_thaali" do
      subject(:sabeels) { described_class.took_thaali }

      it "returns records who previuosly took thaali" do
        expect(sabeels).to include(prev_sabeel)
      end

      it { expect(sabeels).not_to include(active_sabeel) }
    end

    describe ".with_thaali_size" do
      subject(:sabeels) { described_class.with_thaali_size(:small) }

      let(:large_thaali) { create(:sabeel_large_thaali) }
      let(:small_thaali) { create(:sabeel_small_thaali) }

      it "returns records for provided size" do
        expect(sabeels).to contain_exactly(small_thaali)
      end

      it { is_expected.not_to include(large_thaali) }
    end
  end

  context "when using instance method" do
    describe "address" do
      subject { sabeel.address }

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

        let(:sabeel) { create(:sabeel_took_thaali) }

        it { is_expected.to be_falsy }
      end
    end
  end
end
