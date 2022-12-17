require "rails_helper"

RSpec.describe Transaction, type: :model do
    subject { build(:transaction) }

    context "assocaition" do
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
        context "on_date_must_not_be_in_future" do
            it "must raise error for future dates" do
                subject.on_date = Date.today + 1
                subject.validate
                expect(subject.errors[:on_date]).to include("cannot be in the future")
            end

            it "must pass for present or past dates" do
                subject.on_date = Date.today
                subject.validate
                expect(subject.errors[:on_date]).to_not include("cannot be in the future")
            end
        end
    end

    context "callback method" do
        context "add_transaction_amount_to_paid_amount" do
            it { is_expected.to callback(:add_transaction_amount_to_paid_amount).after(:commit) }

            it "should update the value if takhmeen payment is NOT complete" do
                expect(subject.takhmeen.is_complete).to be_falsey
                previous_paid_amount = subject.takhmeen.paid
                subject.amount = 500
                previous_paid_amount += subject.amount
                subject.save
                expect(subject.takhmeen.paid).to eq(previous_paid_amount)
            end

            it "should NOT update the value if takhmeen payment IS complete" do
                takhmeen_paid_amount = subject.takhmeen.paid = subject.takhmeen.total
                subject.takhmeen.is_complete = true
                subject.amount = 1000
                subject.save
                expect(subject.takhmeen.paid).to eq(takhmeen_paid_amount)
            end
        end
    end
end
