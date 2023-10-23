# frozen_string_literal: true

require "rails_helper"

RSpec.describe Transaction do
  subject(:transaction) { build(:transaction) }

  context "with assocaition" do
    subject { create(:transaction) }

    it { is_expected.to belong_to(:thaali_takhmeen) }
  end

  context "when validating" do
    context "with mode" do
      let(:mode_of_payments) { %i[cash cheque bank] }

      it { is_expected.to validate_presence_of(:mode).with_message("selection is required") }
      it { is_expected.to define_enum_for(:mode).with_values(mode_of_payments) }
    end

    context "with amount" do
      it { is_expected.to validate_numericality_of(:amount).only_integer.with_message("must be an integer") }
      it { is_expected.to validate_numericality_of(:amount).is_greater_than(0) }
      it { expect(transaction.amount).to be_present }

      it "will raise an error if amount is greater than balance" do
        transaction.amount = transaction.thaali_takhmeen.balance + Faker::Number.non_zero_digit
        transaction.validate
        expect(transaction.errors[:amount]).to include("cannot be greater than the balance")
      end

      it "will NOT raise an error if amount is less than or equal to balance" do
        transaction.amount = transaction.thaali_takhmeen.balance - Faker::Number.non_zero_digit
        transaction.validate
        expect(transaction.errors[:amount]).not_to include("cannot be greater than the balance")
      end
    end

    context "with date" do
      today_str = Date.current.strftime("%e %B %Y")

      it { is_expected.to validate_presence_of(:date).with_message("selection is required") }

      it { expect(transaction.date).to be_an_instance_of(Date) }

      describe "will NOT raise an error for past dates" do
        subject { create(:transaction).errors[:date] }

        it { is_expected.not_to include("must be on or before #{today_str}") }
      end

      it "raises error for future dates" do
        transaction.date = Faker::Date.forward
        transaction.validate
        expect(transaction.errors[:date]).to include("must be on or before #{today_str}")
      end
    end

    context "with recipe_no" do
      it { is_expected.to validate_numericality_of(:recipe_no).only_integer.with_message("must be an integer") }
      it { is_expected.to validate_numericality_of(:recipe_no).is_greater_than(0) }
      it { is_expected.to validate_uniqueness_of(:recipe_no).with_message("has already been invoiced") }
    end
  end

  context "when saving" do
    describe "#add_all_transaction_amounts_to_paid_amount" do
      let(:takhmeen) { transaction.thaali_takhmeen }
      let(:all_transactions_of_a_takhmeen) { takhmeen.transactions }

      it { is_expected.to callback(:add_all_transaction_amounts_to_paid_amount).after(:commit) }

      it "adds all the transaction amounts if it has ONE OR MORE transactions" do
        transaction.save

        total_takhmeen = all_transactions_of_a_takhmeen.pluck(:amount).sum(0)
        expect(takhmeen.paid).to eq(total_takhmeen)
      end

      it "paid amount is 0 if it has NO transactions" do
        transaction.destroy
        expect(transaction.thaali_takhmeen.paid).to eq(0)
      end
    end
  end

  context "when using scope" do
    describe "returns all transactions for the given date" do
      let(:today) { Time.zone.now.to_date }

      it "for today" do
        todays_transactions = create(:today_transactions)
        expect(described_class.that_occured_on(today)).to contain_exactly(todays_transactions)
      end

      it "Not of yesterdays" do
        yesterdays_transactions = create(:yesterday_transactions)
        expect(described_class.that_occured_on(today)).not_to contain_exactly(yesterdays_transactions)
      end
    end
  end
end
