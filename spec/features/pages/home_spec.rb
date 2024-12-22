# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Page Home template, displays" do
  before { visit root_path }

  describe "header" do
    it "has a logo" do
      within("#home__header") { expect(page).to have_css("img[src*='logos/fmb']") }
    end
  end

  describe "body" do
    it "has header tags & CTA button" do
      within("#home__body") do
        expect(page).to have_css("h5")
        expect(page).to have_css("h2")
        expect(page).to have_link("Free demo", href: login_path)
      end
    end
  end

  it { expect(page).to have_css("#footer") }
end
