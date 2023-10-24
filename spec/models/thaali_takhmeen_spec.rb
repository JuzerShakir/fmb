# frozen_string_literal: true

require "rails_helper"

RSpec.describe ThaaliTakhmeen do
  subject(:thaali) { build(:thaali_takhmeen) }

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

    context "with paid" do
      it { is_expected.to validate_numericality_of(:paid).only_integer.with_message("must be an integer") }
      it { is_expected.to validate_numericality_of(:paid).is_greater_than_or_equal_to(0) }
      it { expect(thaali.paid).to be_eql(0) }
    end

    context "with is_complete" do
      it "must set its value to false after instance is persisted" do
        expect(thaali.is_complete).to be_falsey
      end
    end
  end

  context "when saving" do
    describe "#update_balance" do
      it { is_expected.to callback(:update_balance).before(:save) }

      it "must instantiate balance attribute with same amount as total attribute amount" do
        thaali.save
        expect(thaali.balance).to eq(thaali.total)
      end
    end

    describe "#check_if_balance_is_zero" do
      it { is_expected.to callback(:check_if_balance_is_zero).before(:save) }

      it "must set is_complete attribute to truthy" do
        thaali.paid = thaali.total = Faker::Number.number(digits: 5)
        thaali.save
        expect(thaali.is_complete).to be_truthy
      end
    end
  end

  context "when using scope" do
    let!(:current_year_takhmeen) { create(:active_takhmeen) }
    let!(:previous_year_takhmeen) { create(:previous_takhmeen) }

    describe ".in_the_year" do
      it "returns all the thaalis of current year" do
        expect(described_class.in_the_year(CURR_YR)).to contain_exactly(current_year_takhmeen)
      end

      it "does not return thaalis of other years" do
        expect(described_class.in_the_year(CURR_YR)).not_to contain_exactly(previous_year_takhmeen)
      end
    end

    describe ".pending" do
      let!(:completed_takhmeen) { create(:completed_takhmeens) }

      it "returns all the thaalis for whos takhmeen is pending" do
        expect(described_class.pending).to contain_exactly(current_year_takhmeen, previous_year_takhmeen)
      end

      it "does not return thaalis whose takhmeen is complete for any year" do
        expect(described_class.pending).not_to contain_exactly(completed_takhmeen)
      end
    end

    describe ".pending_year" do
      it "returns all the thaalis whos takhmeen is pending for the current year" do
        expect(described_class.pending_year(CURR_YR)).to contain_exactly(current_year_takhmeen)
      end

      it "does not return thaalis of current year whos takhmeen is pending for the other years" do
        expect(described_class.pending_year(CURR_YR)).not_to contain_exactly(previous_year_takhmeen)
      end
    end
  end
end
