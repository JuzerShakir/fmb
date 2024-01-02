# frozen_string_literal: true

require "rails_helper"

RSpec.describe Thaali do
  subject(:thaali) { build(:thaali) }

  context "with association" do
    it { is_expected.to belong_to(:sabeel) }
    it { is_expected.to have_many(:transactions).dependent(:destroy) }
  end

  context "with attributes" do
    it { is_expected.to have_readonly_attribute(:year) }
    it { is_expected.to have_readonly_attribute(:total) }

    describe "set default values of" do
      it { expect(described_class.new.year).to eq(CURR_YR) }
      it { expect(described_class.new.size).to be_nil }
    end
  end

  context "when validating" do
    context "with number" do
      it { is_expected.to validate_numericality_of(:number).only_integer.with_message("must be an integer") }
      it { is_expected.to validate_numericality_of(:number).is_greater_than(0) }
    end

    context "with size" do
      it { is_expected.to define_enum_for(:size).with_values(described_class::SIZES.to_h { [_1, _1.to_s.titleize] }).backed_by_column_of_type(:enum) }
      it { is_expected.to validate_presence_of(:size).with_message("selection is required") }
    end

    context "with year" do
      it { is_expected.to validate_numericality_of(:year).only_integer.with_message("must be an integer") }
      it { is_expected.to validate_numericality_of(:year).is_less_than_or_equal_to(CURR_YR) }
      it { is_expected.to validate_uniqueness_of(:year).scoped_to(:sabeel_id) }
    end

    context "with total" do
      it { is_expected.to validate_numericality_of(:total).only_integer.with_message("must be an integer") }
      it { is_expected.to validate_numericality_of(:total).is_greater_than(0) }
    end
  end

  context "when using scope" do
    let(:current_year_thaali) { create(:taking_thaali) }
    let(:previous_year_thaali) { create(:took_thaali) }
    let(:thaali_due) { create(:taking_thaali_partial_amount_paid) }
    let(:completed_thaali) { create(:taking_thaali_dues_cleared) }

    describe ".dues_cleared_in" do
      subject(:thaalis) { described_class.dues_cleared_in(CURR_YR) }

      it "returns all records whos dues are not cleared" do
        expect(thaalis).to include completed_thaali
      end

      it { expect(thaalis).not_to include(previous_year_thaali, current_year_thaali) }
    end

    describe ".dues_unpaid" do
      subject(:thaalis) { described_class.dues_unpaid }

      it "returns all records who have no transaction history" do
        expect(thaalis).to include(current_year_thaali, previous_year_thaali)
      end

      it "returns all records who have transaction history" do
        expect(thaalis).to include(thaali_due)
      end

      it { expect(thaalis).not_to include(completed_thaali) }
    end

    describe ".dues_unpaid_for" do
      subject(:thaalis) { described_class.dues_unpaid_for(CURR_YR) }

      let(:current_year_thaali_with_transactions) { create(:taking_thaali_partial_amount_paid) }

      it "returns all recrods who have no transaction history for the year provided" do
        expect(thaalis).to include(current_year_thaali)
      end

      it "returns all records who have transaction history for the year provided" do
        expect(thaalis).to include(current_year_thaali_with_transactions)
      end

      it { expect(thaalis).not_to contain_exactly(previous_year_thaali) }
    end

    describe ".for_year" do
      subject(:thaalis) { described_class.for_year(CURR_YR) }

      it "returns all records for the year provided" do
        expect(thaalis).to contain_exactly(current_year_thaali)
      end

      it { expect(thaalis).not_to contain_exactly(previous_year_thaali) }
    end

    describe ".no_transaction" do
      subject(:thaalis) { described_class.no_transaction }

      it "returns all recrods who have no transaction history" do
        expect(thaalis).to include(current_year_thaali, previous_year_thaali)
      end

      it { expect(thaalis).not_to include(completed_thaali) }
    end

    describe "partial_amount_paid" do
      subject(:thaalis) { described_class.partial_amount_paid }

      it "returns all records whos dues are not cleared" do
        expect(thaalis).to include(thaali_due)
      end

      it { expect(thaalis).not_to include(completed_thaali) }
    end
  end
end
