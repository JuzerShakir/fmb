require "rails_helper"

RSpec.describe Transaction, type: :routing do

    context "index action" do
        it "is accessible by / route" do
            expect(get("/transactions/all")).to route_to("transactions#index")
        end

        it "is accessible by root route" do
            expect(get: all_transactions_path).to route_to(controller: "transactions", action: "index")
        end
    end

    context "new action" do
        it "is accessible by /sabeel/takhmeen/transaction/new route" do
            expect(get("/sabeel/takhmeen/transaction/new")).to route_to("transactions#new")
        end

        it "is accessible by new_takhmeen_transaction_path route" do
            expect(get: new_takhmeen_transaction_path).to route_to(controller: "transactions", action: "new")
        end
    end

    context "create action" do
        it "is accessible by /sabeel/takhmeen/transaction route" do
            expect(post("/sabeel/takhmeen/transaction")).to route_to("transactions#create")
        end

        it "is accessible by sabeel_takhmeen_transaction route" do
            expect(post: sabeel_takhmeen_transaction_path).to route_to(controller: "transactions", action: "create")
        end
    end

    context "show action" do
        it "is accessible by /sabeel/takhmeen/transaction route" do
            expect(get("/sabeel/takhmeen/transaction")).to route_to("transactions#show")
        end

        it "is accessible by sabeel_takhmeen_transaction route" do
            expect(get: sabeel_takhmeen_transaction_path).to route_to(controller: "transactions", action: "show")
        end
    end

    context "edit action" do
        it "is accessible by /sabeel/takhmeen/transaction/edit route" do
            expect(get("/sabeel/takhmeen/transaction/edit")).to route_to("transactions#edit")
        end

        it "is accessible by edit_takhmeen_transaction route" do
            expect(get: edit_takhmeen_transaction_path).to route_to(controller: "transactions", action: "edit")
        end
    end

    context "update action" do
        it "is accessible by /sabeel/takhmeen/transaction route" do
            expect(patch("/sabeel/takhmeen/transaction")).to route_to("transactions#update")
        end

        it "is accessible by sabeel_takhmeen_transaction route" do
            expect(patch: sabeel_takhmeen_transaction_path).to route_to(controller: "transactions", action: "update")
        end
    end

    context "destroy action" do
        it "is accessible by /sabeel/takhmeen/transaction route" do
            expect(delete("/sabeel/takhmeen/transaction")).to route_to("transactions#destroy")
        end

        it "is accessible by sabeel_takhmeen_transaction route" do
            expect(delete: sabeel_takhmeen_transaction_path).to route_to(controller: "transactions", action: "destroy")
        end
    end
end