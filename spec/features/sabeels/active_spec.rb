# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sabeel Active template" do
  let(:user) { create(:user) }
  let!(:sabeel) { create(:active_sabeel_burhani) }
  let(:thaali) { sabeel.thaalis.first }

  before do
    page.set_rack_session(user_id: user.id)
    visit sabeels_active_path("burhani")
  end

  # * ALL user types
  describe "visited by any user type", :js do
    describe "Generate PDF button" do
      it { expect(page).to have_button("Generate PDF") }
      it { expect(page).to have_css(".fa-file-pdf") }

      describe "Generates PDF of burhani building" do
        let(:pdf_window) { switch_to_window(windows.last) }

        before { click_button("Generate PDF") }

        # FIXME: for the test to pass in github actions wait 5 sec until the header appears
        it { within_window pdf_window { expect(page).to have_content("Burhani - #{CURR_YR}") } }
        it { within_window pdf_window { expect(page).to have_content(sabeel.flat_no) } }
        it { within_window pdf_window { expect(page).to have_content(sabeel.name) } }
        it { within_window pdf_window { expect(page).to have_content(sabeel.mobile) } }
        it { within_window pdf_window { expect(page).to have_content(thaali.number) } }
        it { within_window pdf_window { expect(page).to have_content(thaali.size.humanize.chr) } }
      end
    end

    describe "showing active sabeel details" do
      it { expect(page).to have_content(sabeel.flat_no) }
      it { expect(page).to have_content(sabeel.name) }
      it { expect(page).to have_content(thaali.number) }
      it { expect(page).to have_content(thaali.size.humanize.chr) }
    end
  end
end
