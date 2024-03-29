# frozen_string_literal: true

require "rails_helper"

RSpec.describe Transaction do
  # * ALL
  describe "all action" do
    it "is accessible by /transactions route" do
      expect(get("/transactions")).to route_to("transactions#all")
    end

    it "is accessible by transactions_all_path url helper" do
      expect(get: transactions_all_path).to route_to(controller: "transactions", action: "all")
    end
  end

  # * NEW
  describe "new action" do
    it "is accessible by /thaalis/:thaali_id/transactions/new route" do
      expect(get("/thaalis/1/transactions/new")).to route_to("transactions#new", thaali_id: "1")
    end

    it "is accessible by new_thaali_transaction_path url helper" do
      expect(get: new_thaali_transaction_path(1)).to route_to(controller: "transactions", action: "new", thaali_id: "1")
    end
  end

  # * CREATE
  describe "create action" do
    it "is accessible by /thaalis/:thaali_id/transactions route" do
      expect(post("/thaalis/1/transactions")).to route_to("transactions#create", thaali_id: "1")
    end

    it "is accessible by thaali_transactions_path url helper" do
      expect(post: thaali_transactions_path(1)).to route_to(controller: "transactions", action: "create", thaali_id: "1")
    end
  end

  #  * SHOW
  describe "show action" do
    it "is accessible by /transactions/1 route" do
      expect(get("/transactions/1")).to route_to("transactions#show", id: "1")
    end

    it "is accessible by transaction_path url helper" do
      expect(get: transaction_path(1)).to route_to(controller: "transactions", action: "show", id: "1")
    end
  end

  # * EDIT
  describe "edit action" do
    it "is accessible by /transactions/1/edit route" do
      expect(get("/transactions/1/edit")).to route_to("transactions#edit", id: "1")
    end

    it "is accessible by edit_transaction_path url helper" do
      expect(get: edit_transaction_path(1)).to route_to(controller: "transactions", action: "edit", id: "1")
    end
  end

  # * UPDATE
  describe "update action" do
    it "is accessible by /transactions/1 route" do
      expect(patch("/transactions/1")).to route_to("transactions#update", id: "1")
    end

    it "is accessible by transaction_path url helper" do
      expect(patch: transaction_path(1)).to route_to(controller: "transactions", action: "update", id: "1")
    end
  end

  # * DESTROY
  describe "destroy action" do
    it "is accessible by /transactions/1 route" do
      expect(delete("/transactions/1")).to route_to("transactions#destroy", id: "1")
    end

    it "is accessible by transaction_path url helper" do
      expect(delete: transaction_path(1)).to route_to(controller: "transactions", action: "destroy", id: "1")
    end
  end
end
