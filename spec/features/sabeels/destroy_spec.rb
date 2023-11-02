# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Sabeel destroy" do
  let(:user) { create(:user) }
  let(:sabeel) { create(:sabeel) }

  before do
    page.set_rack_session(user_id: user.id)
    visit sabeel_path(sabeel)
    click_button "Delete"
  end

  it "shows confirmation message" do
    within(".modal-body") do
      expect(page).to have_content("Are you sure you want to delete this Sabeel? This action cannot be undone.")
    end
  end

  context "with action buttons" do
    it { within(".modal-footer") { expect(page).to have_css(".btn-secondary", text: "Cancel") } }
    it { within(".modal-footer") { expect(page).to have_css(".btn-primary", text: "Yes, delete it!") } }
  end

  describe "by" do
    before { click_button "Yes, delete it!" }

    # * Admin
    describe "Admin or Member" do
      let(:user) { create(:admin_user) }

      it { expect(page).to have_current_path root_path, ignore_query: true }

      it { expect(page).to have_content("Sabeel deleted successfully") }
    end

    # * Viewer or Member
    describe "by Viewer" do
      let(:user) { create(:user_member_or_viewer) }

      it { expect(page).to have_content("Not Authorized") }
      it { expect(page).to have_current_path sabeel_path(sabeel) }
    end
  end
end
