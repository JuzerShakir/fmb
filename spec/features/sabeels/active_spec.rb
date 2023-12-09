# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sabeel Active template" do
  let(:user) { create(:user) }
  let!(:sabeel) { create(:burhani_sabeel_taking_thaali) }

  before do
    page.set_rack_session(user_id: user.id)
    visit sabeels_active_path("burhani")
  end

  # * ALL user types
  describe "visited by any user type", :js do
    describe "Generate PDF button" do
      let(:thaali) { sabeel.thaalis.first }

      it { expect(page).to have_link("Generate PDF") }
      it { expect(page).to have_css(".fa-file-pdf") }

      describe "Generates PDF of burhani building" do
        let(:pdf_window) { switch_to_window(windows.last) }

        before { click_link("Generate PDF") }

        it { within_window pdf_window { expect(page).to have_content("Burhani - #{CURR_YR}") } }
        it { within_window pdf_window { expect(page).to have_content(sabeel.flat_no) } }
        it { within_window pdf_window { expect(page).to have_content(sabeel.name) } }
        it { within_window pdf_window { expect(page).to have_content(sabeel.mobile) } }
        it { within_window pdf_window { expect(page).to have_content(thaali.number) } }
        it { within_window pdf_window { expect(page).to have_content(thaali.size.humanize.chr) } }
      end
    end

    describe "showing active sabeel details" do
      it { expect(page).to have_content(sabeel.its) }
      it { expect(page).to have_content(sabeel.name) }
      it { expect(page).to have_content(sabeel.apartment.titleize) }
    end
  end
end
