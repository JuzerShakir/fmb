# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Thaali destroy" do
  let(:user) { create(:user_admin_or_member) }
  let(:thaali) { create(:thaali) }

  before do
    sign_in(user)
    visit thaali_path(thaali)
    click_on "Delete"
  end

  # * Admin or Member
  describe "by Admin or Member" do
    it "shows confirmation message" do
      within(".modal-body") do
        expect(page).to have_content("Are you sure you want to delete this Thaali? This action cannot be undone.")
      end
    end

    it "with action buttons" do
      within(".modal-footer") do
        expect(page).to have_css(".btn-light", text: "Cancel")
        expect(page).to have_css(".btn-danger", text: "Yes, delete it!")
      end
    end

    context "when clicking 'delete button'" do
      before { click_on "Yes, delete it!" }

      it "redirects to the sabeel show page of deleted thaali" do
        expect(page).to (have_current_path sabeel_path(thaali.sabeel)).and have_content("Thaali destroyed")
      end
    end
  end
end
