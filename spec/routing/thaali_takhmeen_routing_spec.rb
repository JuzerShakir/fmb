require "rails_helper"

RSpec.describe ThaaliTakhmeen, type: :routing do

    context "new action" do
        it "routes /sabeel/thaali_takhmeens/new to the new action of thaali_takhmeens controller" do
            expect(get("/sabeel/thaali_takhmeens/new")).to route_to("thaali_takhmeens#new")
        end

        it "routes new_sabeel_thaali_takhmeen to the new action of thaali_takhmeens controller" do
            expect(get: new_sabeel_thaali_takhmeen_path).to route_to(controller: "thaali_takhmeens", action: "new")
        end
    end

    context "create action" do
        it "routes /sabeel/thaali_takhmeens to the create action of thaali_takhmeens controller" do
            expect(post("/sabeel/thaali_takhmeens")).to route_to("thaali_takhmeens#create")
        end

        it "routes sabeel_thaali_takhmeens to the create action of thaali_takhmeens controller" do
            expect(post: sabeel_thaali_takhmeens_path).to route_to(controller: "thaali_takhmeens", action: "create")
        end
    end

    context "show action" do
        it "routes /thaali_takhmeen to the show action of thaali_takhmeens controller" do
            expect(get("/thaali_takhmeens/1")).to route_to("thaali_takhmeens#show", id: "1")
        end

        # it "routes thaali_takhmeen_path to the show action of thaali_takhmeens controller" do
        #     expect(get: thaali_takhmeen_path).to route_to(controller: "thaali_takhmeens", action: "show")
        # end
    end

    context "edit action" do
        it "routes /thaali_takhmeen to the edit action of thaali_takhmeens controller" do
            expect(get("/thaali_takhmeens/1/edit")).to route_to("thaali_takhmeens#edit", id: "1")
        end

        # it "routes edit_thaali_takhmeen_path to the edit action of thaali_takhmeens controller" do
        #     expect(get: edit_thaali_takhmeen_path).to route_to(controller: "thaali_takhmeens", action: "edit")
        # end
    end

    context "update action" do
        it "routes /thaali_takhmeen to the update action of thaali_takhmeens controller" do
            expect(patch("/thaali_takhmeens/1")).to route_to("thaali_takhmeens#update", id: "1")
        end

        # it "routes thaali_takhmeen_path to the update action of thaali_takhmeens controller" do
        #     expect(patch: thaali_takhmeen_path).to route_to(controller: "thaali_takhmeens", action: "update")
        # end
    end

    context "destroy action" do
        it "routes /thaali_takhmeen to the destroy action of thaali_takhmeens controller" do
            expect(delete("/thaali_takhmeens/1")).to route_to("thaali_takhmeens#destroy", id: "1")
        end

        # it "routes thaali_takhmeen_path to the destroy action of thaali_takhmeens controller" do
        #     expect(delete: thaali_takhmeen_path).to route_to(controller: "thaali_takhmeens", action: "destroy")
        # end
    end
end