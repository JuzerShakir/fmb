# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Thaali destroy" do
  let(:user) { create(:user_admin_or_member) }
  let(:thaali) { create(:thaali) }

  before do
    page.set_rack_session(user_id: user.id)
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

    context "with action buttons" do
      it { within(".modal-footer") { expect(page).to have_css(".btn-light", text: "Cancel") } }
      it { within(".modal-footer") { expect(page).to have_css(".btn-danger", text: "Yes, delete it!") } }
    end

    context "when clicking 'delete button'" do
      before { click_on "Yes, delete it!" }

      it { expect(page).to have_current_path sabeel_path(thaali.sabeel) }
      it { expect(page).to have_content("Thaali destroyed") }
    end
  end
end
