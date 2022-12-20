require "rails_helper"

RSpec.describe Takhmeen, type: :model do
    subject { build(:takhmeen) }
    today = Date.today
    yesterday = Date.today.prev_day
    current_year = today.year
    next_year = today.next_year.year

    context "association" do
        it { should belong_to(:thaali) }
        it { should have_many(:transactions) }
    end

    context "validation of attribute" do
        context "year" do
            it { should validate_presence_of(:year) }
            it { should validate_numericality_of(:year).only_integer }

            it { should validate_numericality_of(:year).is_greater_than_or_equal_to(current_year) }

            it { should validate_uniqueness_of(:year).scoped_to(:thaali_id) }
        end

        context "total" do
            it { should validate_presence_of(:total) }

            it { should validate_numericality_of(:total).only_integer }

            it { should validate_numericality_of(:total).is_greater_than(0) }
        end

        context "paid" do
            it { should validate_presence_of(:paid) }

            it { should validate_numericality_of(:paid).only_integer }

            it { should validate_numericality_of(:paid).is_greater_than_or_equal_to(0) }

            it "is set to 0 by default after instance is instantiated" do
                expect(subject.paid).to be_eql(0)
            end
        end

        context "is_complete" do
            it "must set its value to false after instance is persisted" do
                expect(subject.is_complete).to be_falsey
            end
        end
    end

    context "callback method" do
        context "#update_balance" do
            it { is_expected.to callback(:update_balance).before(:save) }

            it "must instantiate balance attribute with same amount as total attribute amount" do
                subject.save
                expect(subject.balance).to eq(subject.total)
            end
        end

        context "#check_if_balance_is_zero" do
            it { is_expected.to callback(:check_if_balance_is_zero).before(:save) }

            it "must set is_complete attribute to truthy" do
                subject.paid = subject.total = Faker::Number.number(digits: 5)
                subject.save
                expect(subject.is_complete).to be_truthy
            end
        end
    end
end