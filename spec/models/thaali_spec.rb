require "rails_helper"

RSpec.describe Thaali, type: :model do
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
            let!(:thaalis_in_current_year) { create(:takhmeen, year: Date.current.year) }
            let!(:thaalis_in_next_year) { create(:takhmeen, year: Date.current.next_year.year) }

            it "should return all the thaalis of current year" do
                expect(described_class.in_the_year(Date.current.year)).to contain_exactly(thaalis_in_current_year.thaali)
            end

            it "should NOT return thaalis of other years" do
                expect(described_class.in_the_year(Date.current.year)).not_to contain_exactly(thaalis_in_next_year.thaali)
            end
        end
    end
end