require "rails_helper"

RSpec.describe User, type: :model do
    subject { build(:user) }

    context "validations of attribute" do
        context "ITS" do
            it { should validate_numericality_of(:its).only_integer.with_message("must be a number") }

            it { should validate_numericality_of(:its).is_in(10000000..99999999).with_message("is invalid") }

            it { should validate_uniqueness_of(:its).with_message("has already been registered") }

            it { should validate_presence_of(:its).with_message("cannot be blank") }
        end

        context "name" do
            it { should validate_presence_of(:name).with_message("cannot be blank")  }

            it { should validate_length_of(:name).is_at_least(3).with_short_message("must be more than 3 characters")  }

            it { should validate_length_of(:name).is_at_most(35).with_long_message("must be less than 35 characters")  }
        end
    end
end
