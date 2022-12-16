require "rails_helper"

RSpec.describe Thaali, type: :model do
    context "validations of" do
        subject { build(:thaali) }

        context "number attribute" do
            it { should validate_numericality_of(:number).only_integer }
            it { should validate_uniqueness_of(:number) }
            it { should validate_presence_of(:number) }
            it { should validate_numericality_of(:number).is_greater_than(0) }
        end

        context "size attribute" do
            it { should define_enum_for(:size).with_values([:small, :medium, :large]) }
            it { should validate_presence_of(:size) }
        end
    end

    context "associations" do
        it { should belong_to(:sabeel) }
    end

    context "callback method" do
        subject { create(:thaali) }

        context "takes_thaali_true" do
            it { is_expected.to callback(:takes_thaali_true).after(:save) }

            it "must set parent attribute takes_thaali to true" do
                expect(subject.sabeel.takes_thaali).to be_truthy
            end
        end

        context "takes_thaali_false" do
            it { is_expected.to callback(:takes_thaali_false).after(:destroy) }

            it "must set parent attribute takes_thaali to false" do
                subject.destroy
                expect(subject.sabeel.takes_thaali).to be_falsey
            end
        end
    end
end