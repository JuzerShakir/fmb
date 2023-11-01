# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Thaali Stats template" do
  let(:user) { create(:user) }
  let(:thaalis) { Thaali.for_year(CURR_YR) }

  before do
    page.set_rack_session(user_id: user.id)
    create_list(:taking_thaali, 2)
    create_list(:taking_thaali_dues_cleared, 2)
    visit thaalis_stats_path
  end

  # * All user types
  describe "shows statistic details of all thaalis for current year" do
    it "Total" do
      within("div##{CURR_YR}") do
        total = thaalis.sum(:total)
        expect(page).to have_content(number_with_delimiter(total))
      end
    end

    it "Balance" do
      within("div##{CURR_YR}") do
        balance = thaalis.sum(&:balance)
        expect(page).to have_content(number_with_delimiter(balance))
      end
    end

    it "Complete" do
      within("div##{CURR_YR}") do
        expect(page).to have_selector(:link_or_button,
          "Complete: #{Thaali.dues_cleared_in(CURR_YR).length}")
      end
    end

    it "Pending" do
      within("div##{CURR_YR}") do
        expect(page).to have_selector(:link_or_button,
          "Pending: #{Thaali.dues_unpaid_for(CURR_YR).length}")
      end
    end

    it "each size" do
      within("div##{CURR_YR}") do
        SIZES.each do |size|
          expect(page).to have_content("#{size.capitalize}: #{thaalis.send(size).count}")
        end
      end
    end

    it "total active thaalis count" do
      within("div##{CURR_YR}") do
        expect(page).to have_selector(:link_or_button,
          "Total Thaalis: #{thaalis.count}")
      end
    end
  end
end
