# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Thaali Stats template" do
  let(:user) { create(:user) }
  let(:thaalis) { Thaali.for_year(CURR_YR) }

  before do
    sign_in(user)
    create_list(:taking_thaali, 2)
    create_list(:taking_thaali_dues_cleared, 2)
    visit statistics_thaalis_path
  end

  it { expect(page).to have_title "Thaali Statistics" }

  # * All user types
  describe "shows its statistics for current year" do
    it "Total Payment, Balance Payment, Completed (Paid), Payment Pending, Thaali Size, & Total thaalis count" do
      total = thaalis.sum(:total)
      balance = thaalis.sum(&:balance)

      within("section##{CURR_YR}") do
        # total
        expect(page).to have_humanized_number(total)
        # balance
        expect(page).to have_humanized_number(balance)
        # Complete
        expect(page).to have_selector(:link_or_button, "Complete: #{Thaali.dues_cleared_in(CURR_YR).length}")
        # Pending
        expect(page).to have_selector(:link_or_button, "Pending: #{Thaali.dues_unpaid_for(CURR_YR).length}")
        # Thaali Size
        Thaali::SIZES.each { |k, v| expect(page).to have_content("#{v}: #{thaalis.send(k).count}") }
        # Total Thaalis
        expect(page).to have_selector(:link_or_button, "Total Thaalis: #{thaalis.count}")
      end
    end
  end
end
