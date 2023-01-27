require 'rails_helper'

RSpec.describe User, type: :routing do
    # * NEW
    context "new action" do
        it "is accessible by /login route" do
            expect(get("/login")).to route_to("sessions#new")
        end

        it "is accessible by login_path route" do
            expect(get: login_path).to route_to(controller: "sessions", action: "new")
        end
    end
end