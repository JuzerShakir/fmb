# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sessions destroy" do
  let(:user) { create(:user) }

  before do
    page.set_rack_session(user_id: user.id)
    visit root_path
    click_link "Log out"
  end

  it { expect(page).to have_current_path login_path }

  it { expect(page).to have_content("Logged out") }

  it "does not show the navbar" do
    expect(page).not_to have_css(".navbar")
  end
end
