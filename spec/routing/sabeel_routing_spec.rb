require 'rails_helper'

RSpec.describe Sabeel, type: :routing do

    context "index action" do
        it "is accessible by /sabeels route" do
            expect(get("/sabeels")).to route_to("sabeels#index")
        end

        it "is accessible by all_sabeels route" do
            expect(get: all_sabeels_path).to route_to(controller: "sabeels", action: "index")
        end
    end

    context "new action" do
        it "is accessible by /sabeel route" do
            expect(get("/sabeel/new")).to route_to("sabeels#new")
        end

        it "is accessible by new_sabeel route" do
            expect(get: new_sabeel_path).to route_to(controller: "sabeels", action: "new")
        end
    end

    context "create action" do
        it "is accessible by /sabeel route" do
            expect(post("/sabeel")).to route_to("sabeels#create")
        end

        it "is accessible by sabeel_path route" do
            expect(post: sabeel_path).to route_to(controller: "sabeels", action: "create")
        end
    end

    context "show action" do
        it "is accessible by /sabeel route" do
            expect(get("/sabeel")).to route_to("sabeels#show")
        end

        it "is accessible by sabeel_path route" do
            expect(get: sabeel_path).to route_to(controller: "sabeels", action: "show")
        end
    end

    context "edit action" do
        it "is accessible by /sabeel route" do
            expect(get("/sabeel/edit")).to route_to("sabeels#edit")
        end

        it "is accessible by edit_sabeel_path route" do
            expect(get: edit_sabeel_path).to route_to(controller: "sabeels", action: "edit")
        end
    end

    context "update action" do
        it "is accessible by /sabeel route" do
            expect(patch("/sabeel")).to route_to("sabeels#update")
        end

        it "is accessible by sabeel_path route" do
            expect(patch: sabeel_path).to route_to(controller: "sabeels", action: "update")
        end
    end

    context "destroy action" do
        it "is accessible by /sabeel route" do
            expect(delete("/sabeel")).to route_to("sabeels#destroy")
        end

        it "is accessible by sabeel_path route" do
            expect(delete: sabeel_path).to route_to(controller: "sabeels", action: "destroy")
        end
    end
end
