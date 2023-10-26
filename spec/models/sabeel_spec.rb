# frozen_string_literal: true

require "rails_helper"
require "validates_email_format_of/rspec_matcher"

RSpec.describe Sabeel do
  subject(:sabeel) { build(:sabeel) }

  context "with association" do
    it { is_expected.to have_many(:thaalis).dependent(:destroy) }
    it { is_expected.to have_many(:transactions).through(:thaalis) }
  end

  context "when validating" do
    context "with ITS" do
      it { is_expected.to validate_numericality_of(:its).only_integer.with_message("must be an integer") }

      it "length" do
        sabeel.its = "123456789"
        sabeel.save
        expect(sabeel.errors[:its]).to include("is incorrect")
      end

      it { is_expected.to validate_uniqueness_of(:its).with_message("has already been registered") }
    end

    context "with email" do
      it { is_expected.to validate_email_format_of(:email) }
      it { is_expected.to allow_value(nil).for(:email) }
    end

    context "with name" do
      it { is_expected.to validate_presence_of(:name) }
    end

    context "with apartment" do
      let(:all_apartments) { described_class.apartments.keys }

      it { is_expected.to validate_presence_of(:apartment).with_message("selection is required") }

      it { is_expected.to define_enum_for(:apartment).with_values(all_apartments) }
    end

    context "with flat_no" do
      it { is_expected.to validate_numericality_of(:flat_no).only_integer.with_message("must be an integer") }

      it { is_expected.to validate_numericality_of(:flat_no).is_greater_than(0) }
    end

    context "with mobile" do
      it { is_expected.to validate_numericality_of(:mobile).only_integer.with_message("must be an integer") }

      it "length" do
        sabeel.mobile = 12345678901
        sabeel.save
        expect(sabeel.errors[:mobile]).not_to be_empty
      end
    end
  end

  context "when saving" do
    describe "#capitalize_name" do
      it { is_expected.to callback(:capitalize_name).before(:save).if(:will_save_change_to_name?) }

      it "must return capitalized name" do
        sabeel.name = Faker::Name.name.swapcase
        name_titleize_format = sabeel.name.split.map(&:capitalize).join(" ")
        sabeel.save
        expect(sabeel.name).to eq(name_titleize_format)
      end
    end
  end

  context "when using scope" do
    context "with thaali" do
      thaali_size = :small

      describe "returns sabeels who are currently taking thaali" do
        subject { described_class.active_thaalis(CURR_YR) }

        let(:active_sabeel) { create(:active_sabeel) }

        it { is_expected.to match_array(active_sabeel) }
      end

      describe "returns sabeels who have never taken thaali" do
        subject { described_class.never_taken_thaali }

        let(:sabeel) { create(:sabeel) }

        it { is_expected.to contain_exactly(sabeel) }
      end

      describe "returns all sabeels for the size specified" do
        subject { described_class.with_the_size(thaali_size) }

        let(:large_thaali) { create(:sabeel_large_thaali) }
        let(:small_thaali) { create(:sabeel_small_thaali) }

        it { is_expected.to match_array(small_thaali) }
        it { is_expected.not_to match_array(large_thaali) }
      end
    end

    context "with Apartment - Burhani" do
      let(:inactive_thaali) { create(:burhani_sabeel_with_previous_thaali) }
      let(:active_thaali) { create(:active_sabeel_burhani) }

      describe "returns sabeels who are currently not taking thaali" do
        let(:thaalis) { described_class.inactive_apt_thaalis("burhani") }

        it { expect(thaalis).to include(inactive_thaali) }

        it { expect(thaalis).not_to include(active_thaali) }
      end
    end
  end

  context "when using instance method" do
    describe "address" do
      subject { sabeel.address }

      let(:sabeel) { create(:sabeel) }

      it { is_expected.to eq "#{sabeel.apartment.titleize} #{sabeel.flat_no}" }
    end

    describe "last_year_thaali_dues_cleared?" do
      context "when sabeel has dues cleared" do
        subject { sabeel.last_year_thaali_dues_cleared? }

        let(:sabeel) { create(:sabeel_prev_thaali_dues_cleared) }

        it { is_expected.to be_truthy }
      end

      context "when sabeel has dues" do
        subject { sabeel.last_year_thaali_dues_cleared? }

        let(:sabeel) { create(:sabeel_with_previous_thaali) }

        it { is_expected.to be_falsy }
      end
    end
  end
end
