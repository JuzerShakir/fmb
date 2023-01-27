require 'rails_helper'

RSpec.describe User, type: :routing do

    # * NEW
    context "new action" do
        it "is accessible by /users/new route" do
            expect(get("/users/new")).to route_to("users#new")
        end

        it "is accessible by new_user_path route" do
            expect(get: new_user_path).to route_to(controller: "users", action: "new")
        end
    end

    # * CREATE
    context "create action" do
        it "is accessible by /users route" do
            expect(post("/users")).to route_to("users#create")
        end

        it "is accessible by users_path route" do
            expect(post: users_path).to route_to(controller: "users", action: "create")
        end
    end

    # * INDEX
    context "index action" do
        it "is accessible by /admin route" do
            expect(get("/admin")).to route_to("users#index")
        end

        it "is accessible by admin_path route" do
            expect(get: admin_path).to route_to(controller: "users", action: "index")
        end
    end
end