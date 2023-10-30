# frozen_string_literal: true

require "rails_helper"

RSpec.describe Thaali do
  subject(:thaali) { build(:thaali) }

  context "with association" do
    it { is_expected.to belong_to(:sabeel) }
    it { is_expected.to have_many(:transactions).dependent(:destroy) }
  end

  context "when validating" do
    context "with number" do
      it { is_expected.to validate_numericality_of(:number).only_integer.with_message("must be an integer") }
      it { is_expected.to validate_numericality_of(:number).is_greater_than(0) }
    end

    context "with size" do
      it { is_expected.to define_enum_for(:size).with_values([:small, :medium, :large]) }
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
    let(:current_year_thaali) { create(:active_thaali) }
    let(:previous_year_thaali) { create(:previous_thaali) }
    let(:thaali_due) { create(:thaali_with_transaction) }
    let(:completed_thaali) { create(:active_thaali_dues_cleared) }

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

      let(:current_year_thaali_with_transactions) { create(:active_thaali_with_transactions) }

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

      it { expect(thaalis).not_to include(thaali_due) }
    end

    describe "partial_dues_paid" do
      subject(:thaalis) { described_class.partial_dues_paid }

      it "returns all records whos dues are not cleared" do
        expect(thaalis).to include(thaali_due)
      end

      it { expect(thaalis).not_to include(completed_thaali) }
    end
  end
end
