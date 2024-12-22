# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Transaction destroy" do
  let(:user) { create(:user_admin_or_member) }
  let(:transaction) { create(:transaction) }

  before do
    sign_in(user)
    visit transaction_path(transaction)
    click_on "Delete"
  end

  # * Admin or Member
  describe "Admin or Member" do
    it "shows confirmation message" do
      within(".modal-body") do
        expect(page).to have_content("Are you sure you want to delete this Transaction? This action cannot be undone.")
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

      it "redirects to thaali show page of deleted transaction with success message" do
        expect(page).to (have_current_path thaali_path(transaction.thaali)).and have_content("Transaction destroyed")
      end
    end
  end
end
