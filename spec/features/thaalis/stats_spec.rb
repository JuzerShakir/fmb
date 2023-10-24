# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Thaali Stats template" do
  let(:user) { create(:user) }
  let(:thaalis) { ThaaliTakhmeen.in_the_year(CURR_YR) }

  before do
    page.set_rack_session(user_id: user.id)
    create_list(:active_takhmeen, 2)
    create_list(:active_completed_takhmeens, 2)
    visit takhmeens_stats_path
  end

  describe "shows statistic details of all thaalis for current year" do
    it "Total" do
      within("div##{CURR_YR}") do
        total = thaalis.pluck(:total).sum
        expect(page).to have_content(number_with_delimiter(total))
      end
    end

    it "Balance" do
      within("div##{CURR_YR}") do
        balance = thaalis.pluck(:balance).sum
        expect(page).to have_content(number_with_delimiter(balance))
      end
    end

    it "Complete" do
      within("div##{CURR_YR}") do
        expect(page).to have_selector(:link_or_button,
          "Complete: #{ThaaliTakhmeen.completed_year(CURR_YR).count}")
      end
    end

    it "Pending" do
      within("div##{CURR_YR}") do
        expect(page).to have_selector(:link_or_button,
          "Pending: #{ThaaliTakhmeen.pending_year(CURR_YR).count}")
      end
    end

    it "each size" do
      within("div##{CURR_YR}") do
        ThaaliTakhmeen.sizes.keys.each do |size|
          expect(page).to have_content("#{size.humanize}: #{thaalis.send(size).count}")
        end
      end
    end

    it "total active takhmeens count" do
      within("div##{CURR_YR}") do
        expect(page).to have_selector(:link_or_button,
          "Total Takhmeens: #{thaalis.count}")
      end
    end
  end
end
