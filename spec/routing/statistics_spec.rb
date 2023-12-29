# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Statistics" do
  # * THAALI
  describe "thaali action" do
    it "is accessible by /statistics/thaalis route" do
      expect(get("/statistics/thaalis")).to route_to("statistics#thaalis")
    end

    it "is accessible by statistics_thaalis_path route" do
      expect(get: statistics_thaalis_path).to route_to(controller: "statistics", action: "thaalis")
    end
  end
end
