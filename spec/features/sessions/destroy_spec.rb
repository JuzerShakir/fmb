# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sessions destroy" do
  let(:user) { create(:user) }

  before do
    page.set_rack_session(user_id: user.id)
    visit thaalis_all_path(CURR_YR)
    click_on "Log out"
  end

  it { expect(page).to have_current_path login_path }

  it { expect(page).to have_content("Logged out") }
end
