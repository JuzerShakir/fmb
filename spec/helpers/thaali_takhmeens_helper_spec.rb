require 'rails_helper'

RSpec.describe ThaaliTakhmeensHelper, type: :helper do
  describe "#year_message" do
    it "returns a hint that year is un-editable" do
      expect(helper.year_message).to eq('You cannot change this field')
    end
  end
end
