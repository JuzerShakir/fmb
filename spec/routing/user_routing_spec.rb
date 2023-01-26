require 'rails_helper'

RSpec.describe User, type: :routing do

    context "new action" do
        it "is accessible by /users/new route" do
            expect(get("/users/new")).to route_to("users#new")
        end

        it "is accessible by new_user_path route" do
            expect(get: new_user_path).to route_to(controller: "users", action: "new")
        end
    end

    context "create action" do
        it "is accessible by /users route" do
            expect(post("/users")).to route_to("users#create")
        end

        it "is accessible by users_path route" do
            expect(post: users_path).to route_to(controller: "users", action: "create")
        end
    end
end