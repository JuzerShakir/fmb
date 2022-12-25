require "rails_helper"

RSpec.describe Transaction, type: :routing do

    context "index action" do
        it "routes / to the index action of transactions controller" do
            expect(get("/transactions/all")).to route_to("transactions#index")
        end

        it "routes root to the index action of transactions controller" do
            expect(get: all_transactions_path).to route_to(controller: "transactions", action: "index")
        end
    end

    context "new action" do
        it "routes /sabeel/takhmeen/transaction/new to the new action of transactions controller" do
            expect(get("/sabeel/takhmeen/transaction/new")).to route_to("transactions#new")
        end

        it "routes new_takhmeen_transaction_path to the new action of transactions controller" do
            expect(get: new_takhmeen_transaction_path).to route_to(controller: "transactions", action: "new")
        end
    end

    context "create action" do
        it "routes /sabeel/takhmeen/transaction to the create action of transactions controller" do
            expect(post("/sabeel/takhmeen/transaction")).to route_to("transactions#create")
        end

        it "routes sabeel_takhmeen_transaction to the create action of transactions controller" do
            expect(post: sabeel_takhmeen_transaction_path).to route_to(controller: "transactions", action: "create")
        end
    end

    context "show action" do
        it "routes /sabeel/takhmeen/transaction to the show action of transactions controller" do
            expect(get("/sabeel/takhmeen/transaction")).to route_to("transactions#show")
        end

        it "routes sabeel_takhmeen_transaction to the show action of transactions controller" do
            expect(get: sabeel_takhmeen_transaction_path).to route_to(controller: "transactions", action: "show")
        end
    end

    context "edit action" do
        it "routes /sabeel/takhmeen/transaction/edit to the edit action of transactions controller" do
            expect(get("/sabeel/takhmeen/transaction/edit")).to route_to("transactions#edit")
        end

        it "routes edit_takhmeen_transaction to the edit action of transactions controller" do
            expect(get: edit_takhmeen_transaction_path).to route_to(controller: "transactions", action: "edit")
        end
    end

    context "update action" do
        it "routes /sabeel/takhmeen/transaction to the update action of transactions controller" do
            expect(patch("/sabeel/takhmeen/transaction")).to route_to("transactions#update")
        end

        it "routes sabeel_takhmeen_transaction to the update action of transactions controller" do
            expect(patch: sabeel_takhmeen_transaction_path).to route_to(controller: "transactions", action: "update")
        end
    end

    context "destroy action" do
        it "routes /sabeel/takhmeen/transaction to the destroy action of transactions controller" do
            expect(delete("/sabeel/takhmeen/transaction")).to route_to("transactions#destroy")
        end

        it "routes sabeel_takhmeen_transaction to the destroy action of transactions controller" do
            expect(delete: sabeel_takhmeen_transaction_path).to route_to(controller: "transactions", action: "destroy")
        end
    end
end