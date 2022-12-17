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
    end

    context "callback method" do
        subject { create(:thaali) }

        context "set_takes_thaali_true" do
            it { is_expected.to callback(:set_takes_thaali_true).after(:create) }

            it "must set parent attribute takes_thaali to true" do
                expect(subject.sabeel.takes_thaali).to be_truthy
            end
        end

        context "set_takes_thaali_false" do
            it { is_expected.to callback(:set_takes_thaali_false).after(:destroy) }

            it "must set parent attribute takes_thaali to false" do
                subject.destroy
                expect(subject.sabeel.takes_thaali).to be_falsey
            end
        end
    end
end