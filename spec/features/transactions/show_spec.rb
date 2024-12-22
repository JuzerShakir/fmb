# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Transaction show template" do
  let(:transaction) { create(:transaction) }

  before do
    sign_in(user)
    visit transaction_path(transaction)
  end

  # * ALL user types
  describe "visited by any user type can view" do
    let(:user) { create(:user) }

    it { expect(page).to have_title "Receipt: #{transaction.receipt_number}" }

    it "transaction details" do
      expect(page).to have_content(transaction.receipt_number)
      expect(page).to have_content(number_with_delimiter(transaction.amount))
      expect(page).to have_content(transaction.mode.capitalize)
      expect(page).to have_content(transaction.date.to_fs(:long))
    end
  end

  describe "visited by admin or member can view" do
    let(:user) { create(:user_admin_or_member) }

    describe "action buttons" do
      it_behaves_like "show_edit_delete"
    end
  end

  describe "visited by viewer cannot view" do
    let(:user) { create(:viewer_user) }

    it_behaves_like "hide_edit_delete"
  end
end
