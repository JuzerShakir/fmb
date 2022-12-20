require "rails_helper"

RSpec.describe Transaction, type: :model do
    subject { build(:transaction) }
    today = Date.today
    yesterday = Date.today.prev_day
    current_year = today.year
    next_year = today.next_year.year

    context "assocaition" do
        subject { create(:transaction) }
        it { should belong_to(:takhmeen) }
    end

    context "validation of attribute" do
        context "mode" do
            let(:mode_of_payments) { %i(cash cheque bank) }
            it { should validate_presence_of(:mode) }
            it { should define_enum_for(:mode).with_values(mode_of_payments) }
        end

        context "amount" do
            it { should validate_presence_of(:amount) }
            it { should validate_numericality_of(:amount).only_integer }
            it { should validate_numericality_of(:amount).is_greater_than(0) }
        end

        context "on_date" do
            it { should validate_presence_of(:on_date) }

            it "must have a valid date" do
                expect(subject.on_date).to be_an_instance_of(Date)
            end
        end
    end

    context "custom validation method" do
        context "#on_date_must_not_be_in_future" do
            it "must raise error for future dates" do
                subject.on_date = Faker::Date.forward
                subject.validate
                expect(subject.errors[:on_date]).to include("cannot be in the future")
            end

            it "must pass for present or past dates" do
                subject.on_date = today
                subject.validate
                expect(subject.errors[:on_date]).to_not include("cannot be in the future")
            end
        end

        context "#amount_should_be_less_than_the_balance" do
            it "must raise an error if amount value is greater than balance value" do
                subject.amount = subject.takhmeen.balance + Faker::Number.non_zero_digit
                subject.validate
                expect(subject.errors[:amount]).to include("cannot be greater than the balance")
            end

            it "must NOT raise an error if amount value is less than balance value" do
                subject.amount = subject.takhmeen.balance - Faker::Number.non_zero_digit
                subject.validate
                expect(subject.errors[:amount]).to_not include("cannot be greater than the balance")
            end
        end
    end

    context "callback method" do
        context "#add_all_transaction_amounts_to_paid_amount" do
            it { is_expected.to callback(:add_all_transaction_amounts_to_paid_amount).after(:commit) }

            context "if takhmeen is NOT complete" do
                subject { create(:transaction) }

                let!(:takhmeen) { subject.takhmeen }
                let!(:all_transactions_of_a_takhmeen) { takhmeen.transactions }

                context "with one or more transactions" do
                    it "should add all the transaction amounts" do
                        total_takhmeen = all_transactions_of_a_takhmeen.pluck(:amount).sum(0)
                        expect(takhmeen.paid).to eq(total_takhmeen)
                    end
                end

                context "with no transactions"  do
                    it "should reset paid amount to zero" do
                        subject.destroy
                        expect(subject.takhmeen.paid).to eq(0)
                    end
                end
            end

            context "if takhmeen IS complete" do
                it "should NOT update the paid attribute amount" do
                    takhmeen_paid_amount = subject.takhmeen.paid = subject.takhmeen.total
                    subject.save # is_complete attribute for takhmeen model will be set to true through callback
                    subject.amount = Faker::Number.non_zero_digit
                    subject.save # will NOT update the paid attribute amount as is_complete is set to true
                    expect(subject.takhmeen.paid).to eq(takhmeen_paid_amount)
                end
            end
        end
    end

    context "scope" do
        context ".that_occured_on" do
            let!(:transaction_today) { create(:transaction, on_date: today) }
            let!(:transaction_prev_day) { create(:transaction, on_date: yesterday) }

            it "should return all the transactions that occured on the given date" do
                expect(described_class.that_occured_on(today)).to contain_exactly(transaction_today)
            end

            it "should NOT return the transactions that occured on some other day" do
                expect(described_class.that_occured_on(today)).not_to contain_exactly(transaction_prev_day)
            end
        end
    end
end
