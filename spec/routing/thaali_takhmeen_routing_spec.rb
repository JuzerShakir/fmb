require "rails_helper"

RSpec.describe ThaaliTakhmeen, type: :routing do

    context "index action" do
        it "is accessible by / route" do
            expect(get("/")).to route_to("thaali_takhmeens#index")
        end

        it "is accessible by root url helper" do
            expect(get: root_path).to route_to(controller: "thaali_takhmeens", action: "index")
        end
    end

    context "new action" do
        it "is accessible by /sabeels/1/takhmeens/new route" do
            expect(get("/sabeels/1/takhmeens/new")).to route_to("thaali_takhmeens#new", sabeel_id: "1")
        end

        it "is accessible by new_sabeel_takhmeen_path url helper" do
            expect(get: new_sabeel_takhmeen_path(1)).to route_to(controller: "thaali_takhmeens", action: "new",  sabeel_id: "1")
        end
    end

    context "create action" do
        it "is accessible by /sabeels/1/takhmeens route" do
            expect(post("/sabeels/1/takhmeens")).to route_to("thaali_takhmeens#create",  sabeel_id: "1")
        end

        it "is accessible by sabeel_takhmeens_path url helper" do
            expect(post: sabeel_takhmeens_path(1)).to route_to(controller: "thaali_takhmeens", action: "create",  sabeel_id: "1")
        end
    end

    context "show action" do
        it "is accessible by /takhmeen route" do
            expect(get("/takhmeens/1")).to route_to("thaali_takhmeens#show", id: "1")
        end

        it "is accessible by takhmeen_path url helper" do
            expect(get: takhmeen_path(1)).to route_to(controller: "thaali_takhmeens", action: "show", id: "1")
        end
    end

    context "edit action" do
        it "is accessible by /takhmeens/1/edit route" do
            expect(get("/takhmeens/1/edit")).to route_to("thaali_takhmeens#edit", id: "1")
        end

        it "is accessible by edit_takhmeen_path url helper" do
            expect(get: edit_takhmeen_path(1)).to route_to(controller: "thaali_takhmeens", action: "edit", id: "1")
        end
    end

    context "update action" do
        it "is accessible by /takhmeens/1 route" do
            expect(patch("/takhmeens/1")).to route_to("thaali_takhmeens#update", id: "1")
        end

        it "is accessible by takhmeen_path url helper" do
            expect(patch: takhmeen_path(1)).to route_to(controller: "thaali_takhmeens", action: "update", id: "1")
        end
    end

    context "destroy action" do
        it "is accessible by /takhmeens/1 route" do
            expect(delete("/takhmeens/1")).to route_to("thaali_takhmeens#destroy", id: "1")
        end

        it "is accessible by takhmeen_path url helper" do
            expect(delete: takhmeen_path(1)).to route_to(controller: "thaali_takhmeens", action: "destroy", id: "1")
        end
    end
end