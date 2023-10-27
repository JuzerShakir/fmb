# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ITS attribute" do
  # since ITS attribute belongs to both entities (sabeel & user) and have similar validations, we can perform test on any single entity
  subject(:entity) { [build(:user), build(:sabeel)].sample }

  context "when validating" do
    it { is_expected.to validate_numericality_of(:its).only_integer.with_message("must be an integer") }

    context "with incorrect length" do
      before do
        entity.its = "123456789"
        entity.save
      end

      it { expect(entity.errors[:its]).to include("is incorrect") }
    end

    context "with correct length" do
      before do
        entity.its = "12345678"
        entity.save
      end

      it { expect(entity.errors[:its]).not_to include("is incorrect") }
    end

    it { is_expected.to validate_uniqueness_of(:its).with_message("has already been registered") }
  end
end
