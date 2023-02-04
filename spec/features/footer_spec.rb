require 'rails_helper'

RSpec.describe "Footer shows", js: true do
    before do
        visit login_path
    end

    scenario "fontawesome '©' logo" do
        within "footer" do
            expect(page).to have_css(".fa-copyright")
        end
    end

    scenario "dynammic year" do
        within "footer" do
            expect(page).to have_content("#{Date.current.year}")
        end
    end

    scenario "role of the creator" do
        within "footer" do
            expect(page).to have_content("Developed & Designed")
        end
    end

    scenario "fontawesome '❤' logo" do
        within "footer" do
            expect(page).to have_css(".fa-heart")
        end
    end

    scenario "creator name linking to its portfolio site" do
        within "footer" do
            expect(page).to have_link("Juzer Shakir")
            @window = window_opened_by { click_on  "Juzer Shakir" }

            using_wait_time 2 do
                within_window @window do
                    expect(page).to have_current_path("https://juzershakir.github.io/")
                end
            end
        end
    end
end