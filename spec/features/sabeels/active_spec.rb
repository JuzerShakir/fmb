# frozen_string_literal: true

require "rails_helper"
require_relative "sabeel_helpers"

RSpec.describe "Sabeel Active template" do
  let(:apt) { "Burhani" }
  let(:user) { create(:user) }
  let!(:sabeels) { create_list(:burhani_sabeel_taking_thaali, 2) }

  before do
    sign_in(user)
    visit sabeels_active_path(apt.downcase)
  end

  # * ALL user types
  describe "visited by any user type", :js do
    it { expect(page).to have_title "Active Sabeels - #{apt}" }

    describe "Generate PDF button" do
      let(:sabeel) { sabeels.first }
      let(:thaali) { sabeel.thaalis.first }

      it { expect(page).to have_link("Generate PDF") }
      it { expect(page).to have_css(".fa-file-pdf") }

      describe "Generates PDF of an apartment" do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:pdf_window) { switch_to_window(windows.last) }

        before { click_on("Generate PDF") }

        it { within_window pdf_window { expect(page).to have_content("#{apt} - #{CURR_YR}") } }
        it { within_window pdf_window { expect(page).to have_content(sabeel.flat_no) } }
        it { within_window pdf_window { expect(page).to have_content(sabeel.name) } }
        it { within_window pdf_window { expect(page).to have_content(sabeel.mobile) } }
        it { within_window pdf_window { expect(page).to have_content(thaali.number) } }
        it { within_window pdf_window { expect(page).to have_content(thaali.size.humanize.chr) } }
      end
    end

    describe "showing active sabeel details" do
      it_behaves_like "view sabeel records"
    end
  end
end
