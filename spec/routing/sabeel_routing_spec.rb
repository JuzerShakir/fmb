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
        it "is accessible by /sabeels route" do
            expect(get("/sabeels/new")).to route_to("sabeels#new")
        end

        it "is accessible by new_sabeel route" do
            expect(get: new_sabeel_path).to route_to(controller: "sabeels", action: "new")
        end
    end

    context "create action" do
        it "is accessible by /sabeels route" do
            expect(post("/sabeels")).to route_to("sabeels#create")
        end

        it "is accessible by sabeel_path route" do
            expect(post: sabeels_path).to route_to(controller: "sabeels", action: "create")
        end
    end

    context "show action" do
        it "is accessible by /sabeels route" do
            expect(get("/sabeels/1")).to route_to("sabeels#show", id: "1")
        end

        it "is accessible by sabeel_path route" do
            expect(get: sabeel_path(1)).to route_to(controller: "sabeels", action: "show", id: "1")
        end
    end

    context "edit action" do
        it "is accessible by /sabeels/:id/edit route" do
            expect(get("/sabeels/1/edit")).to route_to("sabeels#edit", id: "1")
        end

        it "is accessible by edit_sabeel_path route" do
            expect(get: edit_sabeel_path(1)).to route_to(controller: "sabeels", action: "edit", id: "1")
        end
    end

    context "update action" do
        it "is accessible by /sabeels/:id route" do
            expect(patch("/sabeels/1")).to route_to("sabeels#update", id: "1")
        end

        it "is accessible by sabeel_path route" do
            expect(patch: sabeel_path(1)).to route_to(controller: "sabeels", action: "update", id: "1")
        end
    end

    context "destroy action" do
        it "is accessible by /sabeels/:id route" do
            expect(delete("/sabeels/1")).to route_to("sabeels#destroy", id: "1")
        end

        it "is accessible by sabeel_path route" do
            expect(delete: sabeel_path(1)).to route_to(controller: "sabeels", action: "destroy", id: "1")
        end
    end

    context "stats action" do
        it "is accessible by /sabeels/stats route" do
            expect(get("/sabeels/stats")).to route_to("sabeels#stats")
        end

        it "is accessible by sabeel_stats_path route" do
            expect(get: stats_sabeels_path).to route_to(controller: "sabeels", action: "stats")
        end
    end

    context "active action" do
        it "is accessible by /sabeels/mohammedi/active route" do
            expect(get("/sabeels/mohammedi/active")).to route_to("sabeels#active", apt: 'mohammedi')
        end

        it "is accessible by active_sabeels_path route" do
            expect(get: active_sabeels_path("mohammedi")).to route_to(controller: "sabeels", action: "active", apt: 'mohammedi')
        end
    end

    context "active pdf action" do
        it "is accessible by /sabeels/mohammedi/active/pdf route" do
            expect(get("/sabeels/mohammedi/active/pdf")).to route_to("sabeels#active_pdf", apt: 'mohammedi')
        end

        it "is accessible by active_pdf_sabeels_path route" do
            expect(get: active_pdf_sabeels_path("mohammedi")).to route_to(controller: "sabeels", action: "active_pdf", apt: 'mohammedi')
        end
    end

    context "inactive action" do
        it "is accessible by /sabeels/mohammedi/inactive route" do
            expect(get("/sabeels/mohammedi/inactive")).to route_to("sabeels#inactive", apt: 'mohammedi')
        end

        it "is accessible by inactive_sabeels_path route" do
            expect(get: inactive_sabeels_path("mohammedi")).to route_to(controller: "sabeels", action: "inactive", apt: 'mohammedi')
        end
    end
end
