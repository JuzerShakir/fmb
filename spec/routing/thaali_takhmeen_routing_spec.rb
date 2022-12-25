require "rails_helper"

RSpec.describe ThaaliTakhmeen, type: :routing do

    context "index action" do
        it "is accessible by / route" do
            expect(get("/")).to route_to("thaali_takhmeens#index")
        end

        it "is accessible by root route" do
            expect(get: root_path).to route_to(controller: "thaali_takhmeens", action: "index")
        end
    end

    context "new action" do
        it "is accessible by /sabeel/takhmeen/new route" do
            expect(get("/sabeel/takhmeen/new")).to route_to("thaali_takhmeens#new")
        end

        it "is accessible by new_sabeel_takhmeen_path route" do
            expect(get: new_sabeel_takhmeen_path).to route_to(controller: "thaali_takhmeens", action: "new")
        end
    end

    context "create action" do
        it "is accessible by /sabeel/takhmeen route" do
            expect(post("/sabeel/takhmeen")).to route_to("thaali_takhmeens#create")
        end

        it "is accessible by sabeel_takhmeen route" do
            expect(post: sabeel_takhmeen_path).to route_to(controller: "thaali_takhmeens", action: "create")
        end
    end

    context "show action" do
        it "is accessible by /sabeel/takhmeen route" do
            expect(get("/sabeel/takhmeen")).to route_to("thaali_takhmeens#show")
        end

        it "is accessible by sabeel_takhmeen_path route" do
            expect(get: sabeel_takhmeen_path).to route_to(controller: "thaali_takhmeens", action: "show")
        end
    end

    context "edit action" do
        it "is accessible by /sabeel/takhmeen/edit route" do
            expect(get("/sabeel/takhmeen/edit")).to route_to("thaali_takhmeens#edit")
        end

        it "is accessible by edit_thaali_takhmeen_path route" do
            expect(get: edit_sabeel_takhmeen_path).to route_to(controller: "thaali_takhmeens", action: "edit")
        end
    end

    context "update action" do
        it "is accessible by /sabeel/takhmeen route" do
            expect(patch("/sabeel/takhmeen")).to route_to("thaali_takhmeens#update")
        end

        it "is accessible by sabeel_takhmeen_path route" do
            expect(patch: sabeel_takhmeen_path).to route_to(controller: "thaali_takhmeens", action: "update")
        end
    end

    context "destroy action" do
        it "is accessible by /sabeel/takhmeen route" do
            expect(delete("/sabeel/takhmeen")).to route_to("thaali_takhmeens#destroy")
        end

        it "is accessible by sabeel_takhmeen_path route" do
            expect(delete: sabeel_takhmeen_path).to route_to(controller: "thaali_takhmeens", action: "destroy")
        end
    end
end