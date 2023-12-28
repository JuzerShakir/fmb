# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Page Home template, displays" do
  before { visit home_path }

  it "logo" do
    within("#home__header") { expect(page).to have_css("img[src*='fmb-logo-full']") }
  end

  it "secondary header" do
    within("#home__body") { expect(page).to have_css("h5") }
  end

  it "primary header" do
    within("#home__body") { expect(page).to have_css("h2") }
  end

  it "CTA button" do
    within("#home__body") { expect(page).to have_link("Free demo", href: login_path) }
  end

  it { expect(page).to have_css("#footer") }
end
