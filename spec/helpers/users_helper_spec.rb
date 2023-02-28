require 'rails_helper'

RSpec.describe UsersHelper, type: :helper do
    describe "#its_message" do
        it "returns a hint about no. of chars allowed" do
            expect(helper.its_message).to eq("must be exactly 8 characters long")
        end
    end

     describe "#name_message" do
        it "returns a hint about the length of the name allowed" do
          expect(helper.name_message).to eq("between 3 to 35 characters long")
        end
     end

     describe "#password_message" do
        it "returns a hint about the length of the password allowed" do
          expect(helper.password_message).to eq("between 6 to 72 characters long")
        end
     end
end