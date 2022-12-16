require "rails_helper"

RSpec.describe "Thaali", type: :model do
    context "validations of" do
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

    context "association" do
        it { should belong_to(:sabeel) }
    end
end