require "rails_helper"

RSpec.describe Transaction, type: :model do
    context "validation of attribute" do
        subject { build(:transaction) }
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
end
