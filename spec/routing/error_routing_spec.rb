require 'rails_helper'

RSpec.describe "Error", type: :routing do
    context "404 (Not Found) route" do
        it "ErrorsController" do
            expect(get("/404")).to route_to("errors#not_found")
        end
    end

    context "500 (Internal Server) route" do
        it "ErrorsController" do
            expect(get("/500")).to route_to("errors#internal_server")
        end
    end
end