# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Thaali pending template" do
  let(:user) { create(:user) }
  let(:thaalis) { Thaali.first(2) }

  before do
    sign_in(user)
    create_list(:taking_thaali, 2)
    visit thaalis_pending_path(CURR_YR)
  end

  # * ALL user types
  describe "visited by any user type can" do
    it { expect(page).to have_title "Pending Takhmeens in #{CURR_YR}" }

    it_behaves_like "view thaali records"
  end
end
