# frozen_string_literal: true

require "rails_helper"

RSpec.describe Transaction do
  subject { build(:transaction) }

  today = Time.zone.now.to_date
  yesterday = today.prev_day

  context "assocaition" do
    subject { create(:transaction) }

    it { is_expected.to belong_to(:thaali_takhmeen) }
  end

  context "validation of attribute" do
    context "mode" do
      let(:mode_of_payments) { %i[cash cheque bank] }

      it { is_expected.to validate_presence_of(:mode).with_message("must be selected") }
      it { is_expected.to define_enum_for(:mode).with_values(mode_of_payments) }
    end

    context "amount" do
      it { is_expected.to validate_numericality_of(:amount).only_integer.with_message("must be a number") }
      it { is_expected.to validate_numericality_of(:amount).is_greater_than(0).with_message("must be greater than 0") }
    end

    context "date" do
      let(:today_str) { Date.current.strftime("%e %B %Y") }

      it { is_expected.to validate_presence_of(:date).with_message("must be selected") }

      it "must have a valid date" do
        expect(subject.date).to be_an_instance_of(Date)
      end

      it "is less than or equal to the current date" do
        subject.date = today
        subject.validate
        expect(subject.errors[:date]).not_to include("must be on or before #{today_str}")
      end

      it "raises error for future dates" do
        subject.date = Faker::Date.forward
        subject.validate
        expect(subject.errors[:date]).to include("must be on or before #{today_str}")
      end
    end

    context "recipe_no" do
      it { is_expected.to validate_numericality_of(:recipe_no).only_integer.with_message("must be a number") }
      it { is_expected.to validate_numericality_of(:recipe_no).is_greater_than(0).with_message("must be greater than 0") }
      it { is_expected.to validate_uniqueness_of(:recipe_no).with_message("has already been registered") }
    end
  end

  context "custom validation method" do
    describe "#amount_should_be_less_than_the_balance" do
      it "amount value should not be nil" do
        expect(subject.amount).to be_present
      end

      context "must raise an error" do
        it "for new transactions" do
          subject.amount = subject.thaali_takhmeen.balance + Faker::Number.non_zero_digit
          subject.validate
          expect(subject.errors[:amount]).to include("cannot be greater than the balance")
        end

        it "for editing existing transaction" do
          takhmeen = create(:thaali_takhmeen)
          trans = create(:transaction, thaali_takhmeen_id: takhmeen.id)

          trans.amount += takhmeen.balance + Random.rand(1..10)
          trans.validate
          expect(trans.errors[:amount]).to include("cannot be greater than the balance")
        end
      end

      it "must NOT raise an error" do
        subject.amount = subject.thaali_takhmeen.balance - Faker::Number.non_zero_digit
        subject.validate
        expect(subject.errors[:amount]).not_to include("cannot be greater than the balance")
      end
    end
  end

  context "callback method" do
    describe "#add_all_transaction_amounts_to_paid_amount" do
      it { is_expected.to callback(:add_all_transaction_amounts_to_paid_amount).after(:commit) }

      context "if takhmeen has ONE OR MORE transactions" do
        subject { create(:transaction) }

        let!(:takhmeen) { subject.thaali_takhmeen }
        let!(:all_transactions_of_a_takhmeen) { takhmeen.transactions }

        it "adds all the transaction amounts" do
          total_takhmeen = all_transactions_of_a_takhmeen.pluck(:amount).sum(0)
          expect(takhmeen.paid).to eq(total_takhmeen)
        end
      end

      context "if takhmeen has NO transactions" do
        it "resets paid amount to zero" do
          subject.destroy
          expect(subject.thaali_takhmeen.paid).to eq(0)
        end
      end
    end
  end

  context "scope" do
    describe ".that_occured_on" do
      let!(:transaction_today) { create(:transaction, date: today) }
      let!(:transaction_prev_day) { create(:transaction, date: yesterday) }

      it "returns all the transactions that occured on the given date" do
        expect(described_class.that_occured_on(today)).to contain_exactly(transaction_today)
      end

      it "does not return the transactions that occured on some other day" do
        expect(described_class.that_occured_on(today)).not_to contain_exactly(transaction_prev_day)
      end
    end
  end
end
