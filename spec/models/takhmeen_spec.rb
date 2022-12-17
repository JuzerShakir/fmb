require "rails_helper"

RSpec.describe Takhmeen, type: :model do
    context "association" do
        it { should belong_to(:thaali) }
    end
end