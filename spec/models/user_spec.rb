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

        context "password" do
            it { should validate_length_of(:password).is_at_least(6).with_short_message("must be more than 6 characters")  }
        end

        context "password_confirmation" do
            it { should validate_presence_of(:password_confirmation).with_message("cannot be blank")  }
        end

        context "role" do
            it { should validate_presence_of(:role).with_message("selection is required") }

            it { should define_enum_for(:role).with_values([:admin, :member, :viewer]) }
        end
    end

    context "callback method" do
        context "#titleize_name" do
            it { is_expected.to callback(:titleize_name).before(:save).if(:will_save_change_to_name?) }

            it "must return capitalized name" do
                subject.name = Faker::Name.name.swapcase
                name_titleize_format = subject.name.split.map(&:capitalize).join(" ")
                expect(subject).to receive(:titleize_name).and_return(name_titleize_format)
                subject.save
            end
        end
    end
end
