require "rails_helper"

RSpec.describe ThaaliTakhmeen, type: :model do
    subject { build(:thaali_takhmeen) }

    today = Date.today
    yesterday = Date.today.prev_day
    current_year = today.year
    next_year = today.next_year.year

    context "association" do
        it { should belong_to(:sabeel) }
        it { should have_many(:transactions).dependent(:destroy) }
    end

    context "validations of attribute" do

        context "number" do
            it { should validate_numericality_of(:number).only_integer }
            it { should validate_presence_of(:number) }
            it { should validate_numericality_of(:number).is_greater_than(0) }
            it { should validate_uniqueness_of(:number).scoped_to(:year) }
        end

        context "size" do
            it { should define_enum_for(:size).with_values([:small, :medium, :large]) }
            it { should validate_presence_of(:size) }
        end

        context "sabeel_id" do
            it { should validate_uniqueness_of(:sabeel_id).scoped_to(:year) }
        end

        context "year" do
            it { should validate_presence_of(:year) }
            it { should validate_numericality_of(:year).only_integer }
            it { should validate_numericality_of(:year).is_greater_than_or_equal_to(current_year) }
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


        context "#set_takes_thaali_true" do
            subject { create(:thaali_takhmeen) }

            it { is_expected.to callback(:set_takes_thaali_true).after(:create) }

            it "must set parent attribute takes_thaali to true" do
                expect(subject.sabeel.takes_thaali).to be_truthy
            end
        end

        context "#set_takes_thaali_false" do
            subject { create(:thaali_takhmeen) }

            it { is_expected.to callback(:set_takes_thaali_false).after(:destroy) }

            it "must set parent attribute takes_thaali to false" do
                subject.destroy
                expect(subject.sabeel.takes_thaali).to be_falsey
            end
        end
    end

    context "scope" do
        let!(:current_year_takhmeen) { create(:thaali_takhmeen_of_current_year) }
        let!(:next_year_takhmeen) { create(:thaali_takhmeen_of_next_year) }

        context ".in_the_year" do
            it "should return all the thaalis of current year" do
                expect(described_class.in_the_year(current_year)).to contain_exactly(current_year_takhmeen)
            end

            it "should NOT return thaalis of other years" do
                expect(described_class.in_the_year(current_year)).not_to contain_exactly(next_year_takhmeen)
            end
        end

        context ".all_pending_takhmeens_till_date" do
            let!(:completed_takhmeen) { create(:thaali_takhmeen_is_complete) }

            it "should return all the thaalis for whos takhmeen is pending" do
                expect(described_class.all_pending_takhmeens_till_date).to contain_exactly(current_year_takhmeen, next_year_takhmeen)
            end

            it "should NOT return thaalis whose takhmeen is complete for any year" do
                expect(described_class.all_pending_takhmeens_till_date).not_to contain_exactly(completed_takhmeen)
            end
        end

        context ".all_pending_takhmeens_for_the_year" do
            it "should return all the thaalis whos takhmeen is pending for the current year" do
                expect(described_class.all_pending_takhmeens_for_the_year(current_year)).to contain_exactly(current_year_takhmeen)
            end

            it "should NOT return thaalis whos takhmeen is pending for the other years" do
                expect(described_class.all_pending_takhmeens_for_the_year(current_year)).not_to contain_exactly(next_year_takhmeen)
            end
        end
    end
end
