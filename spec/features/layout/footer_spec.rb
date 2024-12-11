# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Footer displays" do
  before { visit login_path }

  it "contact" do
    within("footer") { expect(page).to have_content("Contact") }
  end

  describe "contact of" do
    before { click_on "Contact" }

    it "email" do
      within("footer") { expect(page).to have_link(nil, href: "mailto:juzershakir.webdev@gmail.com") }
    end

    it "whatsapp" do
      within("footer") { expect(page).to have_link(nil, href: "https://wa.me/919819393148") }
    end

    it "telegram" do
      within("footer") { expect(page).to have_link(nil, href: "https://t.me/juzershakir") }
    end
  end

  it "about" do
    within("footer") { expect(page).to have_link("About", href: "https://www.thedawoodibohras.com/about-the-bohras/faiz-al-mawaid-al-burhaniyah/") }
  end

  it "dynamic year" do
    within("footer") { expect(page).to have_content(Date.current.year) }
  end

  it "creator name linking to its portfolio site" do
    within("footer") { expect(page).to have_link("Juzer Shakir", href: "https://juzershakir.github.io/") }
  end
end
