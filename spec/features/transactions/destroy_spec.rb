# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Transaction destroy" do
  let(:user) { create(:user_admin_or_member) }
  let(:transaction) { create(:transaction) }

  before do
    page.set_rack_session(user_id: user.id)
    visit transaction_path(transaction)
    click_button "Delete"
  end

  # * Admin or Member
  describe "Admin or Member" do
    it "shows confirmation message" do
      within(".modal-body") do
        expect(page).to have_content("Are you sure you want to delete this Transaction? This action cannot be undone.")
      end
    end

    context "with action buttons" do
      it { within(".modal-footer") { expect(page).to have_css(".btn-secondary", text: "Cancel") } }
      it { within(".modal-footer") { expect(page).to have_css(".btn-primary", text: "Yes, delete it!") } }
    end

    context "when clicking 'delete button'" do
      before { click_button "Yes, delete it!" }

      it { expect(page).to have_current_path thaali_path(transaction.thaali) }
      it { expect(page).to have_content("Transaction destroyed successfully") }
    end
  end
end
