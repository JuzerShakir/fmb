# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Footer shows", :js do
  before do
    visit login_path
  end

  it "fontawesome '©' logo" do
    within "footer" do
      expect(page).to have_css(".fa-copyright")
    end
  end

  it "dynammic year" do
    within "footer" do
      expect(page).to have_content(Date.current.year.to_s)
    end
  end

  it "role of the creator" do
    within "footer" do
      expect(page).to have_content("Developed & Designed")
    end
  end

  it "fontawesome '❤' logo" do
    within "footer" do
      expect(page).to have_css(".fa-heart")
    end
  end

  it "creator name linking to its portfolio site" do
    within "footer" do
      expect(page).to have_link("Juzer Shakir")
      @window = window_opened_by { click_on "Juzer Shakir" }

      using_wait_time 2 do
        within_window @window do
          expect(page).to have_current_path("https://juzershakir.github.io/")
        end
      end
    end
  end
end
