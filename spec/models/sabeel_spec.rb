require "rails_helper"
require "validates_email_format_of/rspec_matcher"

RSpec.describe Sabeel, :type => :model do
    let(:new_sabeel)  { build(:sabeel) }
    let(:persisted_sabeel) { create(:sabeel) }

    context "validation tests" do
        context "of ITS attribute" do
            let(:its) { new_sabeel.its }

            it { should validate_numericality_of(:its).only_integer }

            it "must have a length of exactly 8 digits" do
                expect(its.digits.count).to eq(8)
            end

            it { should validate_uniqueness_of(:its) }

            it { should validate_presence_of(:its) }
        end

        context "of Email attribute" do
            it { should validate_email_format_of(:email) }
        end

        context "of HOF name" do
            it { should validate_presence_of(:hof_name) }

            it { should validate_uniqueness_of(:hof_name) }
        end

        context "of Address attribute" do
            let(:address) { new_sabeel.address }

            it { should validate_presence_of(:address) }

            it "must be in a specific format" do
                expect(address).to match(/\A[a-z]+ [a-z]+ \d+\z/i)
            end
        end

        context "of Mobile attribute" do
            let(:mobile) { new_sabeel.mobile }

            it { should validate_numericality_of(:mobile).only_integer }

            it "must have a length of exactly 10 digits" do
                expect(mobile.digits.count).to eq(10)
            end

            it { should validate_presence_of(:mobile) }

        end

        context "of takes_thaali attribute" do
            # NOT RECOMMENDED BY SHOULDA-MATCHERS GEM
            # it { should validate_inclusion_of(:takes_thaali).in_array([true, false]) }

            it "should default to false after creating a sabeel instance" do
                expect(persisted_sabeel.takes_thaali).not_to be
            end
        end
    end
end