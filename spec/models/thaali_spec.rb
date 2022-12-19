require "rails_helper"

RSpec.describe Thaali, type: :model do
    today = Date.today
    current_year = today.year
    next_year = today.next_year.year

    context "validations of attribute" do
        subject { build(:thaali) }

        context "number" do
            it { should validate_numericality_of(:number).only_integer }
            it { should validate_uniqueness_of(:number) }
            it { should validate_presence_of(:number) }
            it { should validate_numericality_of(:number).is_greater_than(0) }
        end

        context "size" do
            it { should define_enum_for(:size).with_values([:small, :medium, :large]) }
            it { should validate_presence_of(:size) }
        end

        context "sabeel_id"  do
            it { should validate_uniqueness_of(:sabeel_id) }
        end
    end

    context "association" do
        it { should belong_to(:sabeel) }
        it { should have_many(:takhmeens) }
        it { should have_many(:transactions).through(:takhmeens) }
    end

    context "callback method" do
        subject { create(:thaali) }

        context "#set_takes_thaali_true" do
            it { is_expected.to callback(:set_takes_thaali_true).after(:create) }

            it "must set parent attribute takes_thaali to true" do
                expect(subject.sabeel.takes_thaali).to be_truthy
            end
        end

        context "#set_takes_thaali_false" do
            it { is_expected.to callback(:set_takes_thaali_false).after(:destroy) }

            it "must set parent attribute takes_thaali to false" do
                subject.destroy
                expect(subject.sabeel.takes_thaali).to be_falsey
            end
        end
    end

    context "scope" do
        context ".in_the_year" do
            let!(:current_year_takhmeen) { create(:takhmeen, year: current_year) }
            let!(:next_year_takhmeen) { create(:takhmeen, year: next_year) }

            it "should return all the thaalis of current year" do
                expect(described_class.in_the_year(current_year)).to contain_exactly(current_year_takhmeen.thaali)
            end

            it "should NOT return thaalis of other years" do
                expect(described_class.in_the_year(current_year)).not_to contain_exactly(next_year_takhmeen.thaali)
            end
        end

        context "takhmeen" do
            context ".all_pending_takhmeens_till_date" do
                let!(:incomplete_takhmeen) { create(:takhmeen, is_complete: false) }
                let!(:completed_takhmeen) { create(:takhmeen, is_complete: true) }

                it "should return all the thaalis for whos takhmeen is pending" do
                    expect(described_class.all_pending_takhmeens_till_date).to contain_exactly(incomplete_takhmeen.thaali)
                end

                it "should NOT return thaalis whose takhmeen is paid" do
                    expect(described_class.all_pending_takhmeens_till_date).not_to contain_exactly(completed_takhmeen.thaali)
                end
            end

            context ".all_pending_takhmeens_for_the_year" do
                let!(:incomplete_takhmeen_for_current_year) { create(:takhmeen, is_complete: false, year: current_year) }
                let!(:incomplete_takhmeen_for_other_years) { create(:takhmeen, is_complete: true, year: next_year) }

                it "should return all the thaalis whos takhmeen is pending for the current year" do
                    expect(described_class.all_pending_takhmeens_for_the_year(current_year)).to contain_exactly(incomplete_takhmeen_for_current_year.thaali)
                end

                it "should NOT return thaalis whos takhmeen is pending for the other years" do
                    expect(described_class.all_pending_takhmeens_for_the_year(next_year)).not_to contain_exactly(incomplete_takhmeen_for_other_years.thaali)
                end
            end
        end
    end
end