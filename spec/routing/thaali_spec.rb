# frozen_string_literal: true

require "rails_helper"

RSpec.describe Thaali do
  #  * NEW
  describe "new action" do
    it "is accessible by /sabeels/1/thaalis/new route" do
      expect(get("/sabeels/1/thaalis/new")).to route_to("thaalis#new", sabeel_id: "1")
    end

    it "is accessible by new_sabeel_thaali_path url helper" do
      expect(get: new_sabeel_thaali_path(1)).to route_to(controller: "thaalis", action: "new", sabeel_id: "1")
    end
  end

  # * CREATE
  describe "create action" do
    it "is accessible by /sabeels/1/thaalis route" do
      expect(post("/sabeels/1/thaalis")).to route_to("thaalis#create", sabeel_id: "1")
    end

    it "is accessible by sabeel_thaalis_path url helper" do
      expect(post: sabeel_thaalis_path(1)).to route_to(controller: "thaalis", action: "create", sabeel_id: "1")
    end
  end

  # * SHOW
  describe "show action" do
    it "is accessible by /thaalis/x route" do
      expect(get("/thaalis/1")).to route_to("thaalis#show", id: "1")
    end

    it "is accessible by thaali_path url helper" do
      expect(get: thaali_path(1)).to route_to(controller: "thaalis", action: "show", id: "1")
    end
  end

  # * EDIT
  describe "edit action" do
    it "is accessible by /thaalis/1/edit route" do
      expect(get("/thaalis/1/edit")).to route_to("thaalis#edit", id: "1")
    end

    it "is accessible by edit_thaali_path url helper" do
      expect(get: edit_thaali_path(1)).to route_to(controller: "thaalis", action: "edit", id: "1")
    end
  end

  # * UPDATE
  describe "update action" do
    it "is accessible by /thaalis/1 route" do
      expect(patch("/thaalis/1")).to route_to("thaalis#update", id: "1")
    end

    it "is accessible by thaali_path url helper" do
      expect(patch: thaali_path(1)).to route_to(controller: "thaalis", action: "update", id: "1")
    end
  end

  #  * DESTROY
  describe "destroy action" do
    it "is accessible by /thaalis/1 route" do
      expect(delete("/thaalis/1")).to route_to("thaalis#destroy", id: "1")
    end

    it "is accessible by thaali_path url helper" do
      expect(delete: thaali_path(1)).to route_to(controller: "thaalis", action: "destroy", id: "1")
    end
  end

  #  * COMPLETE
  describe "complete action" do
    it "is accessible by /thaalis/2022/complete route" do
      expect(get("/thaalis/2022/complete")).to route_to("thaalis#complete", year: "2022")
    end

    it "is accessible by thaalis_complete_path route" do
      expect(get: thaalis_complete_path("2022")).to route_to(controller: "thaalis", action: "complete", year: "2022")
    end
  end

  # * PENDING
  describe "pending action" do
    it "is accessible by /thaalis/2022/pending route" do
      expect(get("/thaalis/2022/pending")).to route_to("thaalis#pending", year: "2022")
    end

    it "is accessible by thaalis_pending_path route" do
      expect(get: thaalis_pending_path("2022")).to route_to(controller: "thaalis", action: "pending", year: "2022")
    end
  end

  # * ALL
  describe "all action" do
    it "is accessible by /thaalis/2021/all route" do
      expect(get("/thaalis/2021/all")).to route_to("thaalis#all", year: "2021")
    end

    it "is accessible by thaalis_all_path route" do
      expect(get: thaalis_all_path("2021")).to route_to(controller: "thaalis", action: "all", year: "2021")
    end
  end
end
