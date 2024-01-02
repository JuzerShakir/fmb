# frozen_string_literal: true

require "rails_helper"

RSpec.describe Transaction do
  subject(:transaction) { build(:transaction) }

  context "with assocaition" do
    subject { create(:transaction) }

    it { is_expected.to belong_to(:thaali) }
  end

  context "with attributes" do
    describe "set default values of" do
      it { expect(described_class.new.mode).to be_nil }
    end
  end

  context "when validating" do
    context "with mode" do
      it { is_expected.to validate_presence_of(:mode).with_message("selection is required") }

      it { is_expected.to define_enum_for(:mode).with_values(described_class::MODES.to_h { [_1, _1.to_s.titleize] }).backed_by_column_of_type(:enum) }
    end

    context "with amount" do
      it { is_expected.to validate_numericality_of(:amount).only_integer.with_message("must be an integer") }
      it { is_expected.to validate_numericality_of(:amount).is_greater_than(0) }
      it { expect(transaction.amount).to be_present }

      context "when amount is greater than balance" do
        before do
          transaction.amount = transaction.thaali.balance + Faker::Number.non_zero_digit
          transaction.validate
        end

        it { expect(transaction.errors[:amount]).to include("cannot be greater than the balance") }
      end

      context "when amount is less than or equal to balance" do
        before do
          transaction.amount = transaction.thaali.balance - Faker::Number.non_zero_digit
          transaction.validate
        end

        it { expect(transaction.errors[:amount]).not_to include("cannot be greater than the balance") }
      end
    end

    context "with date" do
      today = Date.current.to_fs(:short)

      it { is_expected.to validate_presence_of(:date).with_message("selection is required") }

      it { expect(transaction.date).to be_an_instance_of(Date) }

      describe "will NOT raise an error for past dates" do
        subject { create(:transaction).errors[:date] }

        it { is_expected.not_to include("must be on or before #{today}") }
      end

      context "when in future" do
        before do
          transaction.date = Faker::Date.forward
          transaction.validate
        end

        it { expect(transaction.errors[:date]).to include("must be on or before #{today}") }
      end
    end

    context "with recipe_no" do
      it { is_expected.to validate_numericality_of(:recipe_no).only_integer.with_message("must be an integer") }
      it { is_expected.to validate_numericality_of(:recipe_no).is_greater_than(0) }
      it { is_expected.to validate_uniqueness_of(:recipe_no).with_message("has already been invoiced") }
    end
  end

  context "when using scope" do
    describe ".that_occured_on" do
      subject { described_class.that_occured_on(today) }

      let(:today) { Time.zone.now.to_date }
      let(:today_transaction) { create(:today_transaction) }
      let(:yesterday_transaction) { create(:yesterday_transaction) }

      it { is_expected.to contain_exactly(today_transaction) }

      it { is_expected.not_to contain_exactly(yesterday_transaction) }
    end
  end
end
