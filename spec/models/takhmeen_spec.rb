require "rails_helper"

RSpec.describe Takhmeen, type: :model do
    context "association" do
        it { should belong_to(:thaali) }
    end

    context "validation of attribute" do
        subject { build(:takhmeen) }

        context "year" do
            it { should validate_presence_of(:year) }
            it { should validate_numericality_of(:year).only_integer }

            it { should validate_numericality_of(:year).is_greater_than_or_equal_to(2022) }

            it { should validate_uniqueness_of(:year).scoped_to(:thaali_id) }
        end

        context "total" do
            it { should validate_presence_of(:total) }

            it { should validate_numericality_of(:total).only_integer }

            it { should validate_numericality_of(:total).is_greater_than(0) }
        end
    end
end