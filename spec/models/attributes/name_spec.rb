require "rails_helper"

RSpec.describe "Name attribute" do
  # since name attribute belongs to both entities (sabeel & user) and have similar callback, we can perform test on any single entity
  subject(:entity) { [build(:user), build(:sabeel)].sample }

  context "when validating" do
    it { is_expected.to validate_length_of(:name).is_at_least(3).with_short_message("must be more than 3 characters") }
    it { is_expected.to validate_length_of(:name).is_at_most(35).with_long_message("must be less than 35 characters") }
  end

  context "when using callback" do
    describe "#capitalize_name" do
      it { is_expected.to callback(:capitalize_name).before(:save).if(:will_save_change_to_name?) }

      it "must return capitalized name" do
        entity.name = Faker::Name.name.swapcase
        capitalized_format = entity.name.split.map(&:capitalize).join(" ")
        entity.save
        expect(entity.name).to eq(capitalized_format)
      end
    end
  end
end
