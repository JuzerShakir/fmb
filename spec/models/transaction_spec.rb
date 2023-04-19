require "rails_helper"

RSpec.describe Transaction, type: :model do
    subject { build(:transaction) }

    today = Time.zone.now.to_date
    yesterday = today.prev_day

    context "assocaition" do
        subject { create(:transaction) }
        it { should belong_to(:thaali_takhmeen) }
    end

    context "validation of attribute" do
        context "mode" do
            let(:mode_of_payments) { %i(cash cheque bank) }
            it { should validate_presence_of(:mode).with_message("must be selected") }
            it { should define_enum_for(:mode).with_values(mode_of_payments) }
        end

        context "amount" do
            it { should validate_numericality_of(:amount).only_integer.with_message("must be a number") }
            it { should validate_numericality_of(:amount).is_greater_than(0).with_message("must be greater than 0") }
        end

        context "date" do
            it { should validate_presence_of(:date).with_message("must be selected") }

            it "must have a valid date" do
                expect(subject.date).to be_an_instance_of(Date)
            end

            it "should be less than or equal to the current date" do
                subject.date = today
                subject.validate
                expect(subject.errors[:date]).to_not include("cannot be in the future")
            end

            it "should raise error for future dates" do
                subject.date = Faker::Date.forward
                subject.validate
                expect(subject.errors[:date]).to include("cannot be in the future")
            end
        end

        context "recipe_no" do
            it { should validate_numericality_of(:recipe_no).only_integer.with_message("must be a number") }
            it { should validate_numericality_of(:recipe_no).is_greater_than(0).with_message("must be greater than 0") }
            it { should validate_uniqueness_of(:recipe_no).with_message("has already been registered") }
        end
    end

    context "custom validation method" do
        context "#amount_should_be_less_than_the_balance" do
            it "amount value should not be nil" do
                expect(subject.amount.present?).to be_truthy
            end

            context "must raise an error" do
                it "for new transactions" do
                    subject.amount = subject.thaali_takhmeen.balance + Faker::Number.non_zero_digit
                    subject.validate
                    expect(subject.errors[:amount]).to include("cannot be greater than the balance")
                end

                it "for editing existing transaction" do
                    takhmeen = FactoryBot.create(:thaali_takhmeen)
                    trans = FactoryBot.create(:transaction, thaali_takhmeen_id: takhmeen.id)

                    trans.amount += takhmeen.balance + Random.rand(1..10)
                    trans.validate
                    expect(trans.errors[:amount]).to include("cannot be greater than the balance")
                end
            end

            it "must NOT raise an error" do
                subject.amount = subject.thaali_takhmeen.balance - Faker::Number.non_zero_digit
                subject.validate
                expect(subject.errors[:amount]).to_not include("cannot be greater than the balance")
            end
        end
    end

    context "callback method" do
        context "#add_all_transaction_amounts_to_paid_amount" do
            it { is_expected.to callback(:add_all_transaction_amounts_to_paid_amount).after(:commit) }

            context "if takhmeen has ONE OR MORE transactions" do
                subject { create(:transaction) }
                let!(:takhmeen) { subject.thaali_takhmeen }
                let!(:all_transactions_of_a_takhmeen) { takhmeen.transactions }

                it "should add all the transaction amounts" do
                    total_takhmeen = all_transactions_of_a_takhmeen.pluck(:amount).sum(0)
                    expect(takhmeen.paid).to eq(total_takhmeen)
                end
            end

            context "if takhmeen has NO transactions"  do
                it "should reset paid amount to zero" do
                    subject.destroy
                    expect(subject.thaali_takhmeen.paid).to eq(0)
                end
            end
        end
    end

    context "scope" do
        context ".that_occured_on" do
            let!(:transaction_today) { create(:transaction, date: today) }
            let!(:transaction_prev_day) { create(:transaction, date: yesterday) }

            it "should return all the transactions that occured on the given date" do
                expect(described_class.that_occured_on(today)).to contain_exactly(transaction_today)
            end

            it "should NOT return the transactions that occured on some other day" do
                expect(described_class.that_occured_on(today)).not_to contain_exactly(transaction_prev_day)
            end
        end
    end
end
