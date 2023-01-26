require 'rails_helper'

RSpec.describe User, type: :routing do

    context "new action" do
        it "is accessible by /users/new route" do
            expect(get("/users/new")).to route_to("users#new")
        end

        it "is accessible by new_user route" do
            expect(get: new_user_path).to route_to(controller: "users", action: "new")
        end
    end
end