# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Session", type: :routing do
  # * NEW
  context "new action" do
    it "is accessible by /login route" do
      expect(get("/login")).to route_to("sessions#new")
    end

    it "is accessible by login_path route" do
      expect(get: login_path).to route_to(controller: "sessions", action: "new")
    end
  end

  # * CREATE
  context "create action" do
    it "is accessible by /signup route" do
      expect(post("/signup")).to route_to("sessions#create")
    end

    it "is accessible by signup_path route" do
      expect(post: signup_path).to route_to(controller: "sessions", action: "create")
    end
  end

  # * DESTROY
  context "destroy action" do
    it "is accessible by /destroy route" do
      expect(delete("/destroy")).to route_to("sessions#destroy")
    end

    it "is accessible by destroy_path route" do
      expect(delete: destroy_path).to route_to(controller: "sessions", action: "destroy")
    end
  end
end
