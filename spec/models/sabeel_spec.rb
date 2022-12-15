require "rails_helper"
require "validates_email_format_of/rspec_matcher"

RSpec.describe Sabeel, :type => :model do
    let(:new_sabeel)  { build(:sabeel) }
    let(:persisted_sabeel) { create(:sabeel) }

    context "validation tests" do
        context "of ITS attribute" do
            it "must be an integer type" do
                expect(new_sabeel.its).to be_a_kind_of(Integer)
            end

            it "must have a length of exactly 8 digits" do
                expect(new_sabeel.its.digits.count).to eq(8)
            end

            it "must be unique" do
                new_sabeel.its = persisted_sabeel.its
                expect(new_sabeel).not_to be_valid
            end

            it "cannot be null" do
                expect(new_sabeel.its).to be_truthy
            end
        end

        context "of Email attribute" do
            it { should validate_email_format_of(:email) }
        end

        context "of HOF name" do
            it "cannot be null"

            it "must be unique"
        end

        context "of Address attribute" do
            it "cannot be null"

            it "must be in a specific format"
        end

        context "of Mobile attribute" do
            it "must be numerical"

            it "must have a length of exactly 10 digits"

            it "cannot be null"
        end

        context "of Mobile attribute" do
            it "must be a boolean "
        end

        context "of Mobile attribute" do
            it "should default to false after creating a sabeel instance"
        end
    end
end