# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sabeel Edit template" do
  let(:user) { create(:user_other_than_viewer) }
  let(:sabeel) { create(:sabeel) }

  before do
    page.set_rack_session(user_id: user.id)
    visit edit_sabeel_path(sabeel)
  end

  # * Admin & Member types
  describe "updating sabeel" do
    context "with valid values" do
      before do
        fill_in "sabeel_mobile", with: Faker::Number.number(digits: 10)
        click_button "Update Sabeel"
      end

      it { expect(page).to have_current_path sabeel_path(sabeel) }

      it { expect(page).to have_content("Sabeel updated successfully") }
    end

    context "with invalid values" do
      before do
        fill_in "sabeel_mobile", with: 0
        click_button "Update Sabeel"
      end

      it { expect(page).to have_content("Mobile is the wrong length (should be 10 characters)") }
    end
  end
end
