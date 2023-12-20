# frozen_string_literal: true

require "rails_helper"
require_relative "sabeel_helpers"

RSpec.describe "Sabeel Inactive template" do
  # rubocop:disable RSpec/LetSetup
  let(:apt) { "Burhani" }
  let(:user) { create(:user) }
  let!(:sabeels) { create_list(:burhani_sabeel_took_thaali, 2) }
  # rubocop:enable RSpec/LetSetup

  before do
    page.set_rack_session(user_id: user.id)
    visit sabeels_inactive_path(apt.downcase)
  end

  # * ALL user types
  describe "visited by any user type", :js do
    it { expect(page).to have_title "Inactive Sabeels - #{apt}" }

    it_behaves_like "view sabeel records"
  end
end
