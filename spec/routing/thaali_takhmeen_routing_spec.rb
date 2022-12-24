require "rails_helper"

RSpec.describe ThaaliTakhmeen, type: :routing do

    context "index action" do
        it "routes / to the index action of thaali_takhmeens controller" do
            expect(get("/")).to route_to("thaali_takhmeens#index")
        end

        it "routes root to the index action of thaali_takhmeens controller" do
            expect(get: root_path).to route_to(controller: "thaali_takhmeens", action: "index")
        end
    end

    context "new action" do
        it "routes /sabeel/takhmeen/new to the new action of thaali_takhmeens controller" do
            expect(get("/sabeel/takhmeen/new")).to route_to("thaali_takhmeens#new")
        end

        it "routes new_sabeel_takhmeen_path to the new action of thaali_takhmeens controller" do
            expect(get: new_sabeel_takhmeen_path).to route_to(controller: "thaali_takhmeens", action: "new")
        end
    end

    context "create action" do
        it "routes /sabeel/takhmeen to the create action of thaali_takhmeens controller" do
            expect(post("/sabeel/takhmeen")).to route_to("thaali_takhmeens#create")
        end

        it "routes sabeel_takhmeen to the create action of thaali_takhmeens controller" do
            expect(post: sabeel_takhmeen_path).to route_to(controller: "thaali_takhmeens", action: "create")
        end
    end

    context "show action" do
        it "routes /sabeel/takhmeen to the show action of thaali_takhmeens controller" do
            expect(get("/sabeel/takhmeen")).to route_to("thaali_takhmeens#show")
        end

        it "routes sabeel_takhmeen_path to the show action of thaali_takhmeens controller" do
            expect(get: sabeel_takhmeen_path).to route_to(controller: "thaali_takhmeens", action: "show")
        end
    end

    context "edit action" do
        it "routes /sabeel/takhmeen/edit to the edit action of thaali_takhmeens controller" do
            expect(get("/sabeel/takhmeen/edit")).to route_to("thaali_takhmeens#edit")
        end

        it "routes edit_thaali_takhmeen_path to the edit action of thaali_takhmeens controller" do
            expect(get: edit_sabeel_takhmeen_path).to route_to(controller: "thaali_takhmeens", action: "edit")
        end
    end

    context "update action" do
        it "routes /sabeel/takhmeen to the update action of thaali_takhmeens controller" do
            expect(patch("/sabeel/takhmeen")).to route_to("thaali_takhmeens#update")
        end

        it "routes sabeel_takhmeen_path to the update action of thaali_takhmeens controller" do
            expect(patch: sabeel_takhmeen_path).to route_to(controller: "thaali_takhmeens", action: "update")
        end
    end

    context "destroy action" do
        it "routes /sabeel/takhmeen to the destroy action of thaali_takhmeens controller" do
            expect(delete("/sabeel/takhmeen")).to route_to("thaali_takhmeens#destroy")
        end

        it "routes sabeel_takhmeen_path to the destroy action of thaali_takhmeens controller" do
            expect(delete: sabeel_takhmeen_path).to route_to(controller: "thaali_takhmeens", action: "destroy")
        end
    end
end