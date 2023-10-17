# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Error", type: :routing do
  context "404 (Not Found) if user visits an unkonwn link" do
    it "redirects to 'not_found' action" do
      expect(get("/404")).to route_to("errors#not_found")
    end
  end

  context "500 (Internal Server) if server encountered an unexpected condition" do
    it "redirects to 'internal_server' action" do
      expect(get("/500")).to route_to("errors#internal_server")
    end
  end
end
