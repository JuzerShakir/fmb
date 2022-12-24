require 'rails_helper'

RSpec.describe Sabeel, type: :routing do

    context "all" do
        it "routes /sabeels/all to the all action of sabeels controller" do
            expect(get("/sabeels/all")).to route_to("sabeels#all")
        end

        it "routes all_sabeels to the all action of sabeels controller" do
            expect(get: all_sabeels_path).to route_to(controller: "sabeels", action: "all")
        end
    end

    context "new" do
        it "routes /sabeel/new to the new action of sabeels controller" do
            expect(get("/sabeel/new")).to route_to("sabeels#new")
        end

        it "routes new_sabeel to the new action of sabeels controller" do
            expect(get: new_sabeel_path).to route_to(controller: "sabeels", action: "new")
        end
    end

    context "create" do
        it "routes /sabeel to the create action of sabeels controller" do
            expect(post("/sabeel")).to route_to("sabeels#create")
        end

        it "routes sabeel_path to the create action of sabeels controller" do
            expect(post: sabeel_path).to route_to(controller: "sabeels", action: "create")
        end
    end

    context "show" do
        it "routes /sabeel to the show action of sabeels controller" do
            expect(get("/sabeel")).to route_to("sabeels#show")
        end

        it "routes sabeel_path to the show action of sabeels controller" do
            expect(get: sabeel_path).to route_to(controller: "sabeels", action: "show")
        end
    end

    context "edit" do
        it "routes /sabeel to the edit action of sabeels controller" do
            expect(get("/sabeel/edit")).to route_to("sabeels#edit")
        end

        it "routes edit_sabeel_path to the edit action of sabeels controller" do
            expect(get: edit_sabeel_path).to route_to(controller: "sabeels", action: "edit")
        end
    end

    context "update" do
        it "routes /sabeel to the update action of sabeels controller" do
            expect(patch("/sabeel")).to route_to("sabeels#update")
        end

        it "routes sabeel_path to the update action of sabeels controller" do
            expect(patch: sabeel_path).to route_to(controller: "sabeels", action: "update")
        end
    end

    context "destroy" do
        it "routes /sabeel to the destroy action of sabeels controller" do
            expect(delete("/sabeel")).to route_to("sabeels#destroy")
        end

        it "routes sabeel_path to the destroy action of sabeels controller" do
            expect(delete: sabeel_path).to route_to(controller: "sabeels", action: "destroy")
        end
    end
end
