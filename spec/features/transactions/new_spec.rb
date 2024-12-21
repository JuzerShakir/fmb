# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Transaction new template" do
  let(:thaali) { create(:thaali) }

  before do
    sign_in(user)
    visit new_thaali_transaction_path(thaali)
  end

  # * Admins & Members
  describe "Admin or Member can create it" do
    let(:user) { create(:user_admin_or_member) }

    before do
      fill_in "transaction_receipt_number", with: 10
      fill_in "transaction_amount", with: 1
    end

    it { expect(page).to have_title "New Transaction" }

    context "with valid values" do
      let(:new_transaction) { Transaction.last }
      let(:mode) { Transaction.modes.values.sample }

      before do
        choose mode
        click_on "Create Transaction"
      end

      it "redirects to newly created transaction" do
        expect(page).to have_current_path transaction_path(new_transaction)
      end

      it { expect(page).to have_content("Transaction created") }
    end

    context "with invalid values" do
      before { click_on "Create Transaction" }

      it "shows validation error messsage for mode field" do
        expect(page).to have_content("selection is required")
      end
    end
  end
end
