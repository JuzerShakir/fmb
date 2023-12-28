# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Pages" do
  # * home
  describe "home action" do
    it "is accessible by /home route" do
      expect(get("/home")).to route_to("pages#home")
    end

    it "is accessible by home_path route" do
      expect(get: home_path).to route_to(controller: "pages", action: "home")
    end
  end
end
