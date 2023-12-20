# frozen_string_literal: true

require "rails_helper"
require_relative "thaali_helpers"

RSpec.describe "Thaali complete template" do
  let(:user) { create(:user) }
  let(:thaalis) { Thaali.dues_cleared_in(CURR_YR) }

  before do
    page.set_rack_session(user_id: user.id)
    create_list(:taking_thaali_dues_cleared, 2)

    visit thaalis_complete_path(CURR_YR)
  end

  # * ALL user types
  describe "visited by any user type can", :js do
    it { expect(page).to have_title "Completed Takhmeens in #{CURR_YR}" }

    it_behaves_like "view thaali records"
  end
end
