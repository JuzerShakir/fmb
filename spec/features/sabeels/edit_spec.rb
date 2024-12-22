# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sabeel Edit template" do
  let(:user) { create(:user_admin_or_member) }
  let(:sabeel) { create(:sabeel) }

  before do
    sign_in(user)
    visit edit_sabeel_path(sabeel)
  end

  it { expect(page).to have_title "Edit Sabeel" }

  # * Admin & Member types
  describe "updating sabeel" do
    context "with valid values" do
      before do
        fill_in "sabeel_mobile", with: Faker::Number.number(digits: 10)
        click_on "Update Sabeel"
      end

      it "redirects to the sabeel page with success message" do
        expect(page).to (have_current_path sabeel_path(sabeel)).and have_content("Sabeel updated")
      end
    end

    context "with invalid values" do
      before do
        fill_in "sabeel_mobile", with: 0
        click_on "Update Sabeel"
      end

      it { expect(page).to have_content("Mobile is the wrong length (should be 10 characters)") }
    end
  end
end
