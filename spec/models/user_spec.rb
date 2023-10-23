# frozen_string_literal: true

require "rails_helper"

RSpec.describe User do
  subject(:user) { build(:user) }

  context "when validating" do
    context "with ITS" do
      it { is_expected.to validate_numericality_of(:its).only_integer.with_message("must be an integer") }

      # * TODO refactor this
      it "length" do
        user.its = "123456789"
        user.save
        expect(user.errors[:its]).to include("is incorrect")
      end

      it { is_expected.to validate_uniqueness_of(:its).with_message("has already been registered") }
    end

    context "with name" do
      it { is_expected.to validate_length_of(:name).is_at_least(3).with_short_message("must be more than 3 characters") }
      it { is_expected.to validate_length_of(:name).is_at_most(35).with_long_message("must be less than 35 characters") }
    end

    context "with password" do
      it { is_expected.to validate_length_of(:password).is_at_least(6).with_short_message("must be more than 6 characters") }
      it { is_expected.to validate_length_of(:password_confirmation).is_at_least(6).with_short_message("must be more than 6 characters") }
    end

    context "with role" do
      it { is_expected.to validate_presence_of(:role).with_message("selection is required") }

      it { is_expected.to define_enum_for(:role).with_values([:admin, :member, :viewer]) }
    end
  end

  context "when saving" do
    describe "#titleize_name" do
      it { is_expected.to callback(:titleize_name).before(:save).if(:will_save_change_to_name?) }

      it "must return capitalized name" do
        user.name = Faker::Name.name.swapcase
        name_titleize_format = user.name.split.map(&:capitalize).join(" ")
        user.save
        expect(user.name).to eq(name_titleize_format)
      end
    end
  end
end
