# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Pages" do
  # * home
  describe "home action" do
    it "is accessible by / route" do
      expect(get("/")).to route_to("pages#home")
    end

    it "is accessible by root_path route" do
      expect(get: root_path).to route_to(controller: "pages", action: "home")
    end
  end
end
