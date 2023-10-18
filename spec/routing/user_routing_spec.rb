# frozen_string_literal: true

require "rails_helper"

RSpec.describe User do
  # * NEW
  describe "new action" do
    it "is accessible by /users/new route" do
      expect(get("/users/new")).to route_to("users#new")
    end

    it "is accessible by new_user_path route" do
      expect(get: new_user_path).to route_to(controller: "users", action: "new")
    end
  end

  # * CREATE
  describe "create action" do
    it "is accessible by /users route" do
      expect(post("/users")).to route_to("users#create")
    end

    it "is accessible by users_path route" do
      expect(post: users_path).to route_to(controller: "users", action: "create")
    end
  end

  # * INDEX
  describe "index action" do
    it "is accessible by /users route" do
      expect(get("/users")).to route_to("users#index")
    end

    it "is accessible by users_path route" do
      expect(get: users_path).to route_to(controller: "users", action: "index")
    end
  end

  # * SHOW
  describe "show action" do
    it "is accessible by /user/:id route" do
      expect(get("/users/1")).to route_to("users#show", id: "1")
    end

    it "is accessible by user_path route" do
      expect(get: user_path(1)).to route_to(controller: "users", action: "show", id: "1")
    end
  end

  #  * EDIT
  describe "edit action" do
    it "is accessible by /users/:id/edit route" do
      expect(get("/users/1/edit")).to route_to("users#edit", id: "1")
    end

    it "is accessible by edit_user_path route" do
      expect(get: edit_user_path(1)).to route_to(controller: "users", action: "edit", id: "1")
    end
  end

  # * UPDATE
  describe "update action" do
    it "is accessible by /users/:id route" do
      expect(patch("/users/1")).to route_to("users#update", id: "1")
    end

    it "is accessible by user_path route" do
      expect(patch: user_path(1)).to route_to(controller: "users", action: "update", id: "1")
    end
  end

  # * DESTROY
  describe "destroy action" do
    it "is accessible by /users/:id route" do
      expect(delete("/users/1")).to route_to("users#destroy", id: "1")
    end

    it "is accessible by user_path route" do
      expect(delete: user_path(1)).to route_to(controller: "users", action: "destroy", id: "1")
    end
  end
end
