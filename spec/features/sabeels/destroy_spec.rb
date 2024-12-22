# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sabeel destroy" do
  let(:user) { create(:admin_user) }
  let(:sabeel) { create(:sabeel) }

  before do
    sign_in(user)
    visit sabeel_path(sabeel)
    click_on "Delete"
  end

  # * Admin
  describe "Admin" do
    it "shows confirmation message" do
      within(".modal-body") do
        expect(page).to have_content("Are you sure you want to delete this Sabeel? This action cannot be undone.")
      end
    end

    it "shows action buttons" do
      within(".modal-footer") do
        expect(page).to have_css(".btn-light", text: "Cancel")
        expect(page).to have_css(".btn-danger", text: "Yes, delete it!")
      end
    end

    context "when clicking 'delete button'" do
      before { click_on "Yes, delete it!" }

      it "redirects to sabeel index path with success message" do
        expect(page).to (have_current_path sabeels_path(format: :html)).and have_content("Sabeel deleted")
      end
    end
  end
end
