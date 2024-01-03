# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Transaction new template" do
  before do
    page.set_rack_session(user_id: user.id)
    thaali = create(:thaali)
    visit new_thaali_transaction_path(thaali)
  end

  # * Admins & Members
  describe "Admin or Member can create it" do
    let(:user) { create(:user_admin_or_member) }

    before do
      fill_in "transaction_recipe_no", with: 10
      fill_in "transaction_amount", with: 1
    end

    it { expect(page).to have_title "New Transaction" }

    context "with valid values" do
      let(:new_transaction) { Transaction.last }
      let(:mode) { Transaction.modes.values.sample }

      before do
        choose mode
        click_button "Create Transaction"
      end

      it "redirects to newly created transaction" do
        expect(page).to have_current_path transaction_path(new_transaction)
      end

      it { expect(page).to have_content("Transaction created") }
    end

    context "with invalid values" do
      before { click_button "Create Transaction" }

      it "shows validation error messsage for mode field" do
        expect(page).to have_content("selection is required")
      end
    end
  end
end
