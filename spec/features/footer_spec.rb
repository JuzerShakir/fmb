# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Footer displays" do
  before { visit login_path }

  it "dynammic year" do
    within "footer" do
      expect(page).to have_content(Date.current.year.to_s)
    end
  end

  it "creator name linking to its portfolio site" do
    within "footer" do
      expect(page).to have_link("Juzer Shakir", href: "https://juzershakir.github.io/")
    end
  end
end
