# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sabeel destroy" do
  let(:user) { create(:admin_user) }
  let(:sabeel) { create(:sabeel) }

  before do
    page.set_rack_session(user_id: user.id)
    visit sabeel_path(sabeel)
    click_button "Delete"
  end

  # * Admin
  describe "Admin" do
    it "shows confirmation message" do
      within(".modal-body") do
        expect(page).to have_content("Are you sure you want to delete this Sabeel? This action cannot be undone.")
      end
    end

    context "with action buttons" do
      it { within(".modal-footer") { expect(page).to have_css(".btn-light", text: "Cancel") } }
      it { within(".modal-footer") { expect(page).to have_css(".btn-danger", text: "Yes, delete it!") } }
    end

    context "when clicking 'delete button'" do
      before { click_button "Yes, delete it!" }

      it { expect(page).to have_current_path root_path, ignore_query: true }

      it { expect(page).to have_content("Sabeel deleted") }
    end
  end
end
