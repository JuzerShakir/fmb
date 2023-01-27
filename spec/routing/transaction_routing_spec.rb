require "rails_helper"

RSpec.describe Transaction, type: :routing do

    # * INDEX
    context "index action" do
        it "is accessible by /transactions route" do
            expect(get("/transactions")).to route_to("transactions#index")
        end

        it "is accessible by all_transactions_path url helper" do
            expect(get: all_transactions_path).to route_to(controller: "transactions", action: "index")
        end
    end

    # * NEW
    context "new action" do
        it "is accessible by /takhmeens/:takhmeen_id/transactions/new route" do
            expect(get("/takhmeens/1/transactions/new")).to route_to("transactions#new", takhmeen_id: "1")
        end

        it "is accessible by new_takhmeen_transaction_path url helper" do
            expect(get: new_takhmeen_transaction_path(1)).to route_to(controller: "transactions", action: "new", takhmeen_id: "1")
        end
    end

    # * CREATE
    context "create action" do
        it "is accessible by /sabeel/takhmeen/transactions route" do
            expect(post("/takhmeens/1/transactions")).to route_to("transactions#create",  takhmeen_id: "1")
        end

        it "is accessible by takhmeen_transactions_path url helper" do
            expect(post: takhmeen_transactions_path(1)).to route_to(controller: "transactions", action: "create",  takhmeen_id: "1")
        end
    end

    #  * SHOW
    context "show action" do
        it "is accessible by /transactions/1 route" do
            expect(get("/transactions/1")).to route_to("transactions#show", id: "1")
        end

        it "is accessible by transaction_path url helper" do
            expect(get: transaction_path(1)).to route_to(controller: "transactions", action: "show", id: "1")
        end
    end

    # * EDIT
    context "edit action" do
        it "is accessible by /transactions/1/edit route" do
            expect(get("/transactions/1/edit")).to route_to("transactions#edit", id: "1")
        end

        it "is accessible by edit_transaction_path url helper" do
            expect(get: edit_transaction_path(1)).to route_to(controller: "transactions", action: "edit", id: "1")
        end
    end

    # * UPDATE
    context "update action" do
        it "is accessible by /transactions/1 route" do
            expect(patch("/transactions/1")).to route_to("transactions#update", id: "1")
        end

        it "is accessible by transaction_path url helper" do
            expect(patch: transaction_path(1)).to route_to(controller: "transactions", action: "update", id: "1")
        end
    end

    # * DESTROY
    context "destroy action" do
        it "is accessible by /transactions/1 route" do
            expect(delete("/transactions/1")).to route_to("transactions#destroy", id: "1")
        end

        it "is accessible by transaction_path url helper" do
            expect(delete: transaction_path(1)).to route_to(controller: "transactions", action: "destroy", id: "1")
        end
    end
end