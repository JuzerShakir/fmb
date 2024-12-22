# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sabeel New template" do
  before do
    sign_in(user)
    visit new_sabeel_path
  end

  # * Admin
  describe "Admin creating it" do
    let(:user) { create(:admin_user) }

    before do
      attributes_for(:sabeel).except(:apartment).each do |k, v|
        fill_in "sabeel_#{k}", with: v
      end
    end

    it { expect(page).to have_title "New Sabeel" }

    context "with valid values" do
      let(:apartment) { Sabeel.apartments.values.sample }
      let(:sabeel_b) { Sabeel.last }

      before do
        choose apartment
        within("#new_sabeel") { click_on "Create Sabeel" }
      end

      it "redirects to newly created thaali and shows success message" do
        expect(page).to (have_current_path sabeel_path(sabeel_b)).and have_content("Sabeel created")
      end
    end

    it "with invalid values displays an error message" do
      within("#new_sabeel") { click_on "Create Sabeel" }
      expect(page).to have_content("selection is required")
    end
  end

  # * Member or Viewer
  describe "visited by Member or Viewer" do
    let(:user) { create(:user_member_or_viewer) }

    it_behaves_like "an unauthorized action"
  end
end
