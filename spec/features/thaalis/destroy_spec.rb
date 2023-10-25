# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Thaali destroy" do
  let(:user) { create(:user) }
  let(:thaali) { create(:thaali) }

  before do
    page.set_rack_session(user_id: user.id)
    visit thaali_path(thaali)
    click_button "Delete"
  end

  it "shows confirmation message" do
    within(".modal-body") do
      expect(page).to have_content("Are you sure you want to delete this Thaali? This action cannot be undone.")
    end
  end

  context "with action buttons" do
    it { within(".modal-footer") { expect(page).to have_css(".btn-secondary", text: "Cancel") } }
    it { within(".modal-footer") { expect(page).to have_css(".btn-primary", text: "Yes, delete it!") } }
  end

  describe "by" do
    before { click_button "Yes, delete it!" }

    # * Admin or Member
    describe "Admin or Member" do
      let(:user) { create(:user_other_than_viewer) }

      it { expect(page).to have_current_path sabeel_path(thaali.sabeel) }
      it { expect(page).to have_content("Thaali destroyed successfully") }
    end

    # * Viewer
    describe "by Viewer" do
      let(:user) { create(:viewer_user) }

      it { expect(page).to have_content("Not Authorized") }
      it { expect(page).to have_current_path thaali_path(thaali) }
    end
  end
end
