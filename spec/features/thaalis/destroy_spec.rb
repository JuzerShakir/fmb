# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ThaaliTakhmeen destroy" do
  let(:user) { create(:user_other_than_viewer) }
  let(:thaali) { create(:thaali_takhmeen) }

  before do
    page.set_rack_session(user_id: user.id)
    visit takhmeen_path(thaali)
    click_button "Delete"
  end

  # * Admins & Members
  describe "Admin or Member" do
    describe "deleting it" do
      it "shows confirmation message" do
        within(".modal-body") do
          expect(page).to have_content("Are you sure you want to delete this ThaaliTakhmeen? This action cannot be undone.")
        end
      end

      context "with action buttons" do
        it { within(".modal-footer") { expect(page).to have_css(".btn-secondary", text: "Cancel") } }
        it { within(".modal-footer") { expect(page).to have_css(".btn-primary", text: "Yes, delete it!") } }
      end

      describe "destroy" do
        before { click_button "Yes, delete it!" }

        it { expect(page).to have_current_path sabeel_path(thaali.sabeel) }
        it { expect(page).to have_content("Thaali destroyed successfully") }
      end
    end
  end
end
