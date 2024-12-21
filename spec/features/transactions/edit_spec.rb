# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Transaction edit template" do
  let!(:transaction) { create(:transaction) }
  let(:total) { transaction.thaali.total }

  before do
    sign_in(user)
    visit edit_transaction_path(transaction)
  end

  # * Admins & Members
  describe "visited by Admin or Member" do
    let(:user) { create(:user_admin_or_member) }

    it { expect(page).to have_title "Edit Transaction" }

    it "displays correct amount limit (total) as a hint" do
      within(".transaction_amount") do
        expect(page).to have_css("small", text: "Amount shouldn't be greater than: ₹#{total}")
      end
    end

    describe "updating" do
      context "with valid values" do
        before do
          fill_in "transaction_amount", with: Faker::Number.number(digits: 4)
          click_on "Update Transaction"
        end

        it "redirects to newly updated transaction" do
          expect(page).to have_current_path transaction_path(transaction)
        end

        it { expect(page).to have_content("Transaction updated") }
      end

      context "with invalid values" do
        before do
          incorrect_amount = total + Random.rand(1..100)
          fill_in "transaction_amount", with: incorrect_amount
          click_on "Update Transaction"
        end

        it "shows validation error message for amount field" do
          within(".transaction_amount") do
            expect(page).to have_content("Amount cannot be greater than the balance")
          end
        end
      end
    end
  end
end
