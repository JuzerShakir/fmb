# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Transaction new template" do
  let(:user) { create(:user_other_than_viewer) }

  before do
    page.set_rack_session(user_id: user.id)
    thaali = create(:thaali_takhmeen)
    visit new_takhmeen_transaction_path(thaali)

    attributes_for(:transaction).except(:mode, :date).each do |k, v|
      fill_in "transaction_#{k}", with: v
    end
  end

  # * Admins & Members
  describe "Admin or Member can create it" do
    context "with valid values" do
      let(:new_transaction) { Transaction.last }

      before do
        select Transaction.modes.keys.sample.to_s.titleize, from: :transaction_mode
        click_button "Create Transaction"
      end

      it "redirects to newly created transaction" do
        expect(page).to have_current_path transaction_path(new_transaction)
      end

      it { expect(page).to have_content("Transaction created successfully") }
    end

    context "with invalid values" do
      before { click_button "Create Transaction" }

      it "shows validation error messsage for mode field" do
        expect(page).to have_content("selection is required")
      end
    end
  end
end
