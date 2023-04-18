require "rails_helper"

RSpec.describe ThaaliTakhmeen, type: :model do
    subject { build(:thaali_takhmeen) }

    context "association" do
        it { should belong_to(:sabeel) }
        it { should have_many(:transactions).dependent(:destroy) }
    end

    context "validations of attribute" do

        context "number" do
            it { should validate_numericality_of(:number).only_integer.with_message("must be a number") }
            it { should validate_numericality_of(:number).is_greater_than(0).with_message("must be greater than 0") }
            it { should validate_uniqueness_of(:number).scoped_to(:year).with_message("has already been taken for the selected year") }
        end

        context "size" do
            it { should define_enum_for(:size).with_values([:small, :medium, :large]) }
            it { should validate_presence_of(:size).with_message("cannot be blank") }
        end

        context "year" do
            it { should validate_numericality_of(:year).only_integer.with_message("must be a number") }
            it { should validate_numericality_of(:year).is_less_than_or_equal_to($active_takhmeen).with_message("must be less than or equal to #{$active_takhmeen}") }
            it { should validate_uniqueness_of(:year).scoped_to(:sabeel_id).with_message("sabeel is already taking thaali for selected year") }
        end

        context "total" do
            it { should validate_numericality_of(:total).only_integer.with_message("must be a number") }
            it { should validate_numericality_of(:total).is_greater_than(0).with_message("must be greater than 0") }
        end

        context "paid" do
            it { should validate_numericality_of(:paid).only_integer.with_message("must be a number") }
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

    context "scope" do
        let!(:current_year_takhmeen) { create(:active_takhmeen) }
        let!(:previous_year_takhmeen) { create(:previous_takhmeen) }

        context ".in_the_year" do
            it "should return all the thaalis of current year" do
                expect(described_class.in_the_year($active_takhmeen)).to contain_exactly(current_year_takhmeen)
            end

            it "should NOT return thaalis of other years" do
                expect(described_class.in_the_year($active_takhmeen)).not_to contain_exactly(previous_year_takhmeen)
            end
        end

        context ".pending" do
            let!(:completed_takhmeen) { create(:completed_takhmeens) }

            it "should return all the thaalis for whos takhmeen is pending" do
                expect(described_class.pending).to contain_exactly(current_year_takhmeen, previous_year_takhmeen)
            end

            it "should NOT return thaalis whose takhmeen is complete for any year" do
                expect(described_class.pending).not_to contain_exactly(completed_takhmeen)
            end
        end

        context ".pending_year" do
            it "should return all the thaalis whos takhmeen is pending for the current year" do
                expect(described_class.pending_year($active_takhmeen)).to contain_exactly(current_year_takhmeen)
            end

            it "should NOT return thaalis of current year whos takhmeen is pending for the other years" do
                expect(described_class.pending_year($active_takhmeen)).not_to contain_exactly(previous_year_takhmeen)
            end
        end
    end
end
