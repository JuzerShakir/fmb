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

    # * CREATE
    context "create action" do
        it "is accessible by /signup route" do
            expect(post("/signup")).to route_to("sessions#create")
        end

        it "is accessible by signup_path route" do
            expect(post: signup_path).to route_to(controller: "sessions", action: "create")
        end
    end
end