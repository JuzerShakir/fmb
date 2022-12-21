require "rails_helper"

RSpec.describe ThaaliTakhmeen, type: :model do
    today = Date.today
    yesterday = Date.today.prev_day
    current_year = today.year
    next_year = today.next_year.year

    context "association" do
        it { should belong_to(:sabeel) }
    end

    context "validations of attribute" do
        subject { build(:thaali_takhmeen) }

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
end
