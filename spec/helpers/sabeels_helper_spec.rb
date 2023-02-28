require 'rails_helper'

RSpec.describe SabeelsHelper, type: :helper do
    describe "#its_message" do
        it "returns a hint about no. of chars allowed" do
          expect(helper.its_message).to eq("must be exactly 8 characters long")
        end
    end

    describe "#mobile_message" do
        it "returns a hint to not include country code" do
          expect(helper.mobile_message).to eq("without the country code")
        end
    end
end
