# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Footer displays" do
  before { visit login_path }

  it "contact details" do
    within("footer") do
      expect(page).to have_content("Contact")

      click_on "Contact"
      # Email
      expect(page).to have_link(nil, href: "mailto:juzershakir.webdev@gmail.com")
      # WhatsApp
      expect(page).to have_link(nil, href: "https://wa.me/919819393148")
      # Telegram
      expect(page).to have_link(nil, href: "https://t.me/juzershakir")
    end
  end

  it "Other Citations" do
    within "#footer" do
      # About
      expect(page).to have_link("About", href: "https://www.thedawoodibohras.com/about-the-bohras/faiz-al-mawaid-al-burhaniyah/")
      # Year
      expect(page).to have_content(Date.current.year)
      # creator name linking to its portfolio site
      expect(page).to have_link("Juzer Shakir", href: "https://juzershakir.github.io/")
    end
  end
end
