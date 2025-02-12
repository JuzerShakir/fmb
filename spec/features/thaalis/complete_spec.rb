# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Thaali complete template" do
  let(:user) { create(:user) }
  let(:thaalis) { Thaali.dues_cleared_in(CURR_YR) }

  before do
    sign_in(user)
    create_list(:taking_thaali_dues_cleared, 2)
    visit thaalis_complete_path(CURR_YR)
  end

  # * ALL user types
  describe "visited by any user type can" do
    it { expect(page).to have_title "Completed Takhmeens in #{CURR_YR}" }

    it_behaves_like "view thaali records"
  end
end
