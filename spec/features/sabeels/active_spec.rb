# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sabeel Active template" do
  let(:apt) { "Burhani" }
  let(:user) { create(:user) }
  let!(:sabeels) { create_list(:burhani_sabeel_taking_thaali, 2) }

  before do
    sign_in(user)
    visit sabeels_active_path(apt.downcase)
  end

  # * ALL user types
  describe "visited by any user type" do
    it "has a title and Generate PDF button" do
      expect(page).to have_title "Active Sabeels - #{apt}"
      expect(page).to have_link("Generate PDF")
      expect(page).to have_css(".fa-file-pdf")
    end

    describe "Generates PDF of an apartment", :js do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:sabeel) { sabeels.first }
      let(:thaali) { sabeel.thaalis.first }
      let(:pdf) { switch_to_window(windows.last) }

      before { click_on("Generate PDF") }

      it do
        within_window pdf { expect(page).to have_content("#{apt} - #{CURR_YR}") }
        within_window pdf { expect(page).to have_content(sabeel.flat_no) }
        within_window pdf { expect(page).to have_content(sabeel.name) }
        within_window pdf { expect(page).to have_content(sabeel.mobile) }
        within_window pdf { expect(page).to have_content(thaali.number) }
        within_window pdf { expect(page).to have_content(thaali.size.humanize.chr) }
      end
    end

    describe "showing active sabeel details" do
      it_behaves_like "view sabeel records"
    end
  end
end
